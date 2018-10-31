//
//  RJTDatabase.m
//  RJTranslate
//
//  Created by Даниил on 19/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTDatabase.h"
#import <CoreData/CoreData.h>

#import "RJTApplicationEntity.h"
#import "RJTApplicationModel.h"

#import "RJTOperationQueue.h"

@interface RJTDatabase ()
@property (strong, nonatomic) dispatch_queue_t serialBackgroundQueue;
@property (assign, nonatomic) BOOL readOnly;
@property (strong, nonatomic) RJTOperationQueue *operationsQueue;

@property (assign, nonatomic) BOOL wasLoadedSuccessfully;
@end

@implementation RJTDatabase
@dynamic viewContext;

+ (NSURL *)defaultDirectoryURL
{
    NSString *documentsPath = @"/var/mobile/Library/Preferences/RJTranslate/";
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    return [NSURL fileURLWithPath:documentsPath];
}

+ (NSURL *)defaultModelURL
{
    NSString *appSupportPath = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSLocalDomainMask, YES).firstObject;
    NSURL *url = [NSURL fileURLWithPath:[appSupportPath stringByAppendingString:@"/RJTranslate.bundle/RJTranslate.momd"]
                            isDirectory:YES];
    
    return url;
}

+ (instancetype _Nullable)defaultDatabase
{
    __block RJTDatabase *defaultDatabase = nil;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_sync(queue, ^{
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.defaultModelURL];
        if (!model)
            return;
        
        defaultDatabase = [[RJTDatabase alloc] initWithName:@"RJTranslate" managedObjectModel:model];
    });
    
    return defaultDatabase;
}

- (instancetype)initWithName:(NSString *)name managedObjectModel:(NSManagedObjectModel *)model
{
    self = [super initWithName:name managedObjectModel:model];
    if (self) {
        self.operationsQueue = [RJTOperationQueue new];
        self.serialBackgroundQueue = dispatch_queue_create("ru.danpashin.rjtranslate.database", DISPATCH_QUEUE_SERIAL);
        
        [self loadPersistentStore];
    }
    return self;
}

- (void)loadPersistentStore
{
    dispatch_async(self.serialBackgroundQueue, ^{
        NSString *databaseName = [self.name stringByAppendingString:@".sqlite"];
        NSString *bundleIdentfier = [NSBundle mainBundle].bundleIdentifier;
        self.readOnly = ![bundleIdentfier isEqualToString:@"ru.danpashin.RJTranslate"];
        
        NSDictionary *loadingOptions = @{NSReadOnlyPersistentStoreOption:@(self.readOnly),
                                         NSMigratePersistentStoresAutomaticallyOption:@YES,
                                         NSInferMappingModelAutomaticallyOption:@YES};
        
        NSError *loadingError = nil;
        NSURL *databaseURL = [[self.class defaultDirectoryURL] URLByAppendingPathComponent:databaseName];
        [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration:nil
                                                                URL:databaseURL
                                                            options:loadingOptions
                                                              error:&loadingError];
        
        RJTLog(@"Loaded persistent store read-only: %@; with error: %@", @(self.readOnly), loadingError);
        
        if (!loadingError) {
            [self.operationsQueue startAllPending];
        }
        
        self.wasLoadedSuccessfully = !loadingError;
    });
}

- (void)performBackgroundTask:(void (^)(NSManagedObjectContext * _Nonnull))block
{
    __block NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [super performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
            context.stalenessInterval = 0.0f;
            block(context);
        }];
    }];
    
    [self.operationsQueue addOperation:operation startImmediately:self.wasLoadedSuccessfully];
}

- (void)saveContext:(NSManagedObjectContext *)context
{
    if (self.readOnly) {
        RJTErrorLog(@"Persistent store is read-only. Skipping saving.");
        return;
    }
    
    BOOL hasChanges = context.hasChanges;
    if (!hasChanges) {
        RJTLog(@"Context has no changes. Skipping saving.");
        return;
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        RJTErrorLog(@"Unresolved error while saving context: %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)fetchAllAppModelsWithCompletion:(void(^)(NSArray <RJTApplicationModel *>  * _Nonnull allModels))completion
{
    [self performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
        NSFetchRequest *fetchRequest = [RJTApplicationEntity fetchRequest];
        NSArray <RJTApplicationEntity *> *result = [context executeFetchRequest:fetchRequest error:nil];
        
        NSMutableArray <RJTApplicationModel *> *allModels = [NSMutableArray array];
        for (RJTApplicationEntity *entity in result) {
            RJTApplicationModel *model = [RJTApplicationModel copyFromEntity:entity];
            if (model)
                [allModels addObject:model];
        }
        
        completion(allModels);
    }];
}


- (void)fetchAppModelsWithPredicate:(NSPredicate * _Nullable)predicate
                         completion:(void(^)(NSArray <RJTApplicationModel *>  * _Nonnull models))completion
{
    [self fetchAppEntitiesWithPredicate:predicate completion:^(NSArray<RJTApplicationEntity *> * _Nonnull appEntities) {
        NSMutableArray <RJTApplicationModel *> *models = [NSMutableArray array];
        for (RJTApplicationEntity *entity in appEntities) {
            RJTApplicationModel *model = [RJTApplicationModel copyFromEntity:entity];
            if (model)
                [models addObject:model];
        }
        
        completion(models);
    }];
}

- (void)fetchAppEntitiesWithPredicate:(NSPredicate * _Nullable)predicate
                           completion:(void (^)(NSArray<RJTApplicationEntity *> * _Nonnull entities))completion
{
    [self performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
        NSFetchRequest *fetchRequest = [RJTApplicationEntity fetchRequest];
        fetchRequest.predicate = predicate;
    
        NSArray <RJTApplicationEntity *> *result = [context executeFetchRequest:fetchRequest error:nil];
        completion(result ?: @[]);
    }];
}

- (void)insertAppModels:(NSArray <RJTApplicationModel *> *)appModels completion:(void(^_Nullable)(void))completion
{
    if (self.readOnly) {
        RJTErrorLog(@"Persistent store is read-only. Skipping inserting.");
        
        if (completion)
            completion();
        
        return;
    }
    
    [self performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
        for (RJTApplicationModel *appModel in appModels) {
            RJTApplicationEntity *appObject = [RJTApplicationEntity insertIntoContext:context];
            [appObject copyPropertiesFrom:appModel];
        }
        
        [self saveContext:context];
        
        if (completion)
            completion();
    }];
}

- (void)updateModel:(RJTApplicationModel *)appModel
{
    if (self.readOnly) {
        RJTErrorLog(@"Persistent store is read-only. Skipping updating.");
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"displayedName == %@", appModel.displayedName];
    [self fetchAppEntitiesWithPredicate:predicate completion:^(NSArray<RJTApplicationEntity *> * _Nonnull appEntities) {
        if (appEntities.count != 1)
            return;
        
        RJTApplicationEntity *entity = appEntities.firstObject;
        [entity copyPropertiesFrom:appModel];
        [self saveContext:entity.managedObjectContext];
    }];
}

- (void)removeModel:(RJTApplicationModel *)appModel completion:(void(^_Nullable)(NSError * _Nullable error))completion
{
    if (self.readOnly) {
        RJTErrorLog(@"Persistent store is read-only. Skipping removing.");
        
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:0
                                         userInfo:@{NSLocalizedDescriptionKey:@"Persistent store is read-only"}];
        
        if (completion)
            completion(error);
        
        return;
    }
    
    [self performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
        NSFetchRequest *fetchRequest = [RJTApplicationEntity fetchRequest];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"displayedName == %@", appModel.displayedName];
        
        NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
        
        NSError *error = nil;
        [context executeRequest:deleteRequest error:&error];
        
        if (completion)
            completion(error);
    }];
}

@end

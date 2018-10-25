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

@interface RJTDatabase ()
@property (strong, nonatomic) dispatch_queue_t serialBackgroundQueue;
@property (assign, nonatomic) BOOL readOnly;
@property (assign, nonatomic) BOOL storeWasReadSuccessfully;
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

+ (instancetype)defaultDatabase
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
        self.serialBackgroundQueue = dispatch_queue_create("ru.danpashin.rjtranslate.database", DISPATCH_QUEUE_SERIAL);
        dispatch_async(self.serialBackgroundQueue, ^{
            NSString *databaseName = [name stringByAppendingString:@".sqlite"];
            NSString *bundleIdentfier = [NSBundle mainBundle].bundleIdentifier;
            self.readOnly = ![bundleIdentfier isEqualToString:@"ru.danpashin.RJTranslate"];

            NSError *loadingError = nil;
            NSURL *databaseURL = [[self.class defaultDirectoryURL] URLByAppendingPathComponent:databaseName];
            [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:databaseURL options:@{NSReadOnlyPersistentStoreOption:@(self.readOnly)} error:&loadingError];
            if (!loadingError)
                self.storeWasReadSuccessfully = YES;
            
            RJTLog(@"Loaded persistent store read-only: %@; with error: %@", @(self.readOnly), loadingError);
        });
    }
    return self;
}

- (void)performBackgroundTask:(void (^)(NSManagedObjectContext * _Nonnull))block
{
    if (!self.storeWasReadSuccessfully) {
        RJTErrorLog(@"Can not start background task because of error while reading/creating persistent store.");
        return;
    }
    
    [super performBackgroundTask:block];
}

- (void)save
{
    [self saveContext:self.viewContext];
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
    } else {
        RJTLog(@"Context was saved successfully!");
    }
}

- (void)fetchAllAppModelsWithCompletion:(void(^)(NSArray <RJTApplicationModel *>  * _Nonnull allModels))completion
{
    [self fetchAllAppEntitiesWithCompletion:^(NSArray<RJTApplicationEntity *> *allEntities) {
        NSMutableArray <RJTApplicationModel *> *allModels = [NSMutableArray array];
        for (RJTApplicationEntity *entity in allEntities) {
            [allModels addObject:[RJTApplicationModel from:entity]];
        }
        
        completion(allModels);
    }];
}

- (void)fetchAllAppEntitiesWithCompletion:(void(^)(NSArray <RJTApplicationEntity *> * _Nonnull allEntities))completion
{
    dispatch_async(self.serialBackgroundQueue, ^{
        [self performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
            NSFetchRequest *fetchRequest = [RJTApplicationEntity fetchRequest];
            NSArray <RJTApplicationEntity *> *result = [context executeFetchRequest:fetchRequest error:nil];

            completion(result ?: @[]);
        }];
    });
}

- (void)fetchAppModelsWithPredicate:(NSPredicate *)predicate completion:(void(^)(NSArray <RJTApplicationModel *>  * _Nonnull models))completion
{
    [self fetchAppEntitiesWithPredicate:predicate completion:^(NSArray<RJTApplicationEntity *> * _Nonnull appEntities) {
        NSMutableArray <RJTApplicationModel *> *models = [NSMutableArray array];
        for (RJTApplicationEntity *entity in appEntities) {
            [models addObject:[RJTApplicationModel from:entity]];
        }
        
        completion(models);
    }];
}

- (void)fetchAppEntitiesWithPredicate:(NSPredicate *)predicate completion:(void (^)(NSArray<RJTApplicationEntity *> * _Nonnull entities))completion
{
    dispatch_async(self.serialBackgroundQueue, ^{
        [self performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
            NSFetchRequest *fetchRequest = [RJTApplicationEntity fetchRequest];
            fetchRequest.predicate = predicate;
            
            NSArray <RJTApplicationEntity *> *result = [context executeFetchRequest:fetchRequest error:nil];
            completion(result ?: @[]);
        }];
    });
}

- (void)insertAppModels:(NSArray <RJTApplicationModel *> *)appModels completion:(void(^_Nullable)(void))completion
{
    if (self.readOnly) {
        RJTErrorLog(@"Persistent store is read-only. Skipping inserting.");
        return;
    }
    
    dispatch_async(self.serialBackgroundQueue, ^{
        [self performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
            for (RJTApplicationModel *appModel in appModels) {
                RJTApplicationEntity *appObject = [RJTApplicationEntity insertIntoContext:context];
                [appObject copyPropertiesFrom:appModel];
            }
            
            [self saveContext:context];
            
            if (completion)
                completion();
        }];
    });
}

- (void)updateModel:(RJTApplicationModel *)appModel
{
    if (self.readOnly) {
        RJTErrorLog(@"Persistent store is read-only. Skipping updating.");
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bundleIdentifier == %@ AND executableName == %@", appModel.bundleIdentifier, appModel.executableName];
    [self fetchAppEntitiesWithPredicate:predicate completion:^(NSArray<RJTApplicationEntity *> * _Nonnull appEntities) {
        if (appEntities.count != 1)
            return;
        
        RJTApplicationEntity *entity = appEntities.firstObject;
        [entity copyPropertiesFrom:appModel];
        [self saveContext:entity.managedObjectContext];
    }];
}

@end

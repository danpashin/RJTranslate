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
@end

@implementation RJTDatabase
@dynamic viewContext;

+ (NSURL *)defaultDirectoryURL
{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSLocalDomainMask, YES).firstObject;
    return [NSURL fileURLWithPath:[documentsPath stringByAppendingString:@"/RJTranslate/"]];
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
        NSLog(@"[RJTranslate] %@", defaultDatabase.persistentStoreDescriptions);
//        [defaultDatabase loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull description, NSError * _Nullable error) {
//            NSLog(@"[RJTranslate] Loaded persistent store with error: %@", error);
//        }];
    });
    
    return defaultDatabase;
}

- (instancetype)initWithName:(NSString *)name managedObjectModel:(NSManagedObjectModel *)model
{
    self = [super initWithName:name managedObjectModel:model];
    if (self) {
        self.serialBackgroundQueue = dispatch_queue_create("ru.danpashin.rjtranslate.database", DISPATCH_QUEUE_SERIAL);
//        dispatch_async(self.serialBackgroundQueue, ^{
//            [self loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull description, NSError * _Nullable error) {
//                NSLog(@"Loaded persistent store");
//            }];
//        });
    }
    return self;
}

- (void)save
{
    [self saveContext:self.viewContext];
}

- (void)saveContext:(NSManagedObjectContext *)context
{
    NSError *error = nil;
    
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error while saving context: %@, %@", error, error.userInfo);
        abort();
    } else {
        NSLog(@"Context was saved successfully!");
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

- (void)fetchAllAppEntitiesWithCompletion:(void(^)(NSArray <RJTApplicationEntity *> *allEntities))completion
{
    dispatch_async(self.serialBackgroundQueue, ^{
        NSLog(@"Executing fetch request");
//        [self performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
//            NSFetchRequest *fetchRequest = [RJTApplicationEntity fetchRequest];
//            NSArray <RJTApplicationEntity *> *result = [context executeFetchRequest:fetchRequest error:nil];
//
//            completion(result ?: @[]);
//        }];
    });
}

- (void)fetchAppModelsWithPredicate:(NSPredicate *)predicate completion:(void(^)(NSArray <RJTApplicationModel *>  * _Nonnull models))completion
{
    dispatch_async(self.serialBackgroundQueue, ^{
        [self performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
            NSFetchRequest *fetchRequest = [RJTApplicationEntity fetchRequest];
            fetchRequest.predicate = predicate;
            
            NSMutableArray <RJTApplicationModel *> *models = [NSMutableArray array];
            NSArray <RJTApplicationEntity *> *result = [context executeFetchRequest:fetchRequest error:nil];
            for (RJTApplicationEntity *entity in result) {
                [models addObject:[RJTApplicationModel from:entity]];
            }
            
            completion(models);
        }];
    });
}

@end

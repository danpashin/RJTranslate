//
//  RJTDatabaseFacade.m
//  RJTranslate
//
//  Created by Даниил on 07/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

#import "RJTDatabaseFacade.h"
#import "RJTDatabase.h"
#import <CoreData/CoreData.h>

#import "RJTApplicationEntity.h"
#import "RJTApplicationModel.h"

@interface RJTDatabaseFacade ()
@property (strong, nonatomic) RJTDatabase *database;

@end

@implementation RJTDatabaseFacade

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.database = [RJTDatabase defaultDatabase];
    }
    return self;
}


- (NSSortDescriptor *)caseInsensetiveSortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending
{
    return [[NSSortDescriptor alloc] initWithKey:key ascending:ascending
                                        selector:@selector(localizedCaseInsensitiveCompare:)];
}

- (void)fetchAllAppModelsWithCompletion:(void(^)(NSArray <RJTApplicationModel *>  * _Nonnull allModels))completion
{
    [self.database performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
        NSFetchRequest *fetchRequest = [RJTApplicationEntity fetchRequest];
        fetchRequest.sortDescriptors = @[[self caseInsensetiveSortDescriptorWithKey:@"displayedName" ascending:YES]];
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
    [self.database performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
        NSFetchRequest *fetchRequest = [RJTApplicationEntity fetchRequest];
        fetchRequest.sortDescriptors = @[[self caseInsensetiveSortDescriptorWithKey:@"displayedName" ascending:YES]];
        fetchRequest.predicate = predicate;
        
        NSArray <RJTApplicationEntity *> *result = [context executeFetchRequest:fetchRequest error:nil];
        completion(result ?: @[]);
    }];
}

- (void)insertAppModels:(NSArray <RJTApplicationModel *> *)appModels completion:(void(^_Nullable)(void))completion
{
    [self.database performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
        if (self.database.readOnly) {
            RJTErrorLog(nil, @"Persistent store is read-only. Skipping inserting.");
            
            if (completion)
                completion();
            
            return;
        }
        
        for (RJTApplicationModel *appModel in appModels) {
            RJTApplicationEntity *appObject = [RJTApplicationEntity insertIntoContext:context];
            [appObject copyPropertiesFrom:appModel];
        }
        
        if (completion)
            completion();
    }];
}


- (void)updateModel:(RJTApplicationModel *)appModel
{
    [self updateModel:appModel saveContext:YES];
}

- (void)updateModel:(RJTApplicationModel *)appModel saveContext:(BOOL)saveContext
{
    if (self.database.readOnly) {
        RJTErrorLog(nil, @"Persistent store is read-only. Skipping updating.");
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"displayedName == %@", appModel.displayedName];
    [self fetchAppEntitiesWithPredicate:predicate completion:^(NSArray<RJTApplicationEntity *> * _Nonnull appEntities) {
        if (appEntities.count != 1)
            return;
        
        RJTApplicationEntity *entity = appEntities.firstObject;
        [entity copyPropertiesFrom:appModel];
        
        if (saveContext)
            [self.database saveContext:entity.managedObjectContext];
    }];
}

- (void)removeModel:(RJTApplicationModel *)appModel completion:(void(^_Nullable)(NSError * _Nullable error))completion
{
    [self.database performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
        if (self.database.readOnly) {
            RJTErrorLog(nil, @"Persistent store is read-only. Skipping removing.");
            
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:0
                                             userInfo:@{NSLocalizedDescriptionKey:@"Persistent store is read-only"}];
            
            if (completion)
                completion(error);
            
            return;
        }
        
        NSFetchRequest *fetchRequest = [RJTApplicationEntity fetchRequest];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"displayedName == %@", appModel.displayedName];
        
        NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
        
        NSError *error = nil;
        [context executeRequest:deleteRequest error:&error];
        
        if (completion)
            completion(error);
    }];
}


- (void)performModelsSearchWithText:(NSString *)text
                         completion:(void(^)(NSArray <RJTApplicationModel *> * _Nonnull models))completion
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bundleIdentifier BEGINSWITH[cd] %@ OR displayedName BEGINSWITH[cd] %@", text, text];
    [self fetchAppModelsWithPredicate:predicate completion:completion];
}

- (void)performFullDatabaseUpdateWithModels:(NSArray <RJTApplicationModel *> *)models
                                 completion:(void(^ _Nullable)(void))completion
{
    [self fetchAllAppModelsWithCompletion:^(NSArray<RJTApplicationModel *> * _Nonnull allModels) {
        for (RJTApplicationModel *model in models) {
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            if ([allModels containsObject:model]) {
                NSUInteger index = [allModels indexOfObject:model];
                if (index >= 0)
                    model.enableTranslation = allModels[index].enableTranslation;
                
                [self updateModel:model saveContext:NO];
                dispatch_semaphore_signal(semaphore);
            } else {
                [self insertAppModels:@[model] completion:^{
                    dispatch_semaphore_signal(semaphore);
                }];
            }
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        
        for (RJTApplicationModel *model in allModels) {
            if (![models containsObject:model]) {
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                [self removeModel:model completion:^(NSError * _Nullable error) {
                    dispatch_semaphore_signal(semaphore);
                }];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            }
        }
        
        [self.database saveBackgroundContext];
        
        if (completion)
            completion();
    }];
}

@end

//
//  RJTDatabaseAppFacade.m
//  RJTranslate
//
//  Created by Даниил on 04/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

#import "RJTDatabaseAppFacade.h"
#import "RJTDatabase.h"

#import "NSSortDescriptor+RJTExtended.h"
#import "RJTApplicationEntity.h"

#import <RJTranslate-Swift.h>

@implementation RJTDatabaseAppFacade

- (void)fetchAllAppModelsWithCompletion:(void(^)(NSArray <TranslationModel *>  * _Nonnull allModels))completion
{
    [self.database performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
        NSFetchRequest *fetchRequest = [RJTApplicationEntity fetchRequest];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor rjt_caseInsWithKey:@"displayedName" ascending:YES]];
        NSArray <RJTApplicationEntity *> *result = [context executeFetchRequest:fetchRequest error:nil];
        
        NSMutableArray <TranslationModel *> *allModels = [NSMutableArray array];
        for (RJTApplicationEntity *entity in result) {
            TranslationModel *model = [[TranslationModel alloc] initWithEntity:entity lightweight:YES];
            [allModels addObject:model];
        }
        
        completion(allModels);
    }];
}


- (void)fetchAppModelsWithPredicate:(NSPredicate * _Nullable)predicate
                         completion:(void(^)(NSArray <TranslationModel *>  * _Nonnull models))completion
{
    [self fetchAppEntitiesWithPredicate:predicate completion:^(NSArray<RJTApplicationEntity *> * _Nonnull appEntities) {
        NSMutableArray <TranslationModel *> *models = [NSMutableArray array];
        for (RJTApplicationEntity *entity in appEntities) {
            TranslationModel *model = [[TranslationModel alloc] initWithEntity:entity lightweight:YES];
            [models addObject:model];
        }
        
        completion(models);
    }];
}

- (void)addAppModels:(NSArray <TranslationModel *> *)appModels completion:(void(^_Nullable)(void))completion
{
    [self.database performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
        if (self.database.readOnly) {
            RJTErrorLog(nil, @"Persistent store is read-only. Skipping inserting.");
            
            if (completion)
                completion();
            
            return;
        }
        
        for (TranslationModel *appModel in appModels) {
            NSFetchRequest *fetchRequest = [RJTApplicationEntity fetchRequest];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"displayedName == %@", appModel.displayedName];
            NSUInteger count = [context countForFetchRequest:fetchRequest error:nil];
            if (count == 0) {
                RJTApplicationEntity *appObject = [RJTApplicationEntity insertIntoContext:context];
                [appObject copyPropertiesFrom:appModel];
                appObject.installDate = [NSDate date].timeIntervalSince1970;
            }
        }
        
        if (completion)
            completion();
    }];
}

- (void)updateModel:(TranslationModel *)appModel
{
    [self updateModel:appModel saveContext:YES];
}

- (void)updateModel:(TranslationModel *)appModel saveContext:(BOOL)saveContext
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
        entity.installDate = [NSDate date].timeIntervalSince1970;
        
        if (saveContext)
            [self.database saveContext];
    }];
}

- (void)removeModel:(TranslationModel *)appModel completion:(void(^_Nullable)(NSError * _Nullable error))completion
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
                         completion:(void(^)(NSArray <TranslationModel *> * _Nonnull models))completion
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bundleIdentifier BEGINSWITH[cd] %@ OR displayedName BEGINSWITH[cd] %@", text, text];
    [self fetchAppModelsWithPredicate:predicate completion:completion];
}

@end

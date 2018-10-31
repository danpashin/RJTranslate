//
//  RJTDatabase.h
//  RJTranslate
//
//  Created by Даниил on 19/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/NSPersistentContainer.h>

@class RJTApplicationModel, RJTApplicationEntity;

NS_ASSUME_NONNULL_BEGIN

@interface RJTDatabase : NSPersistentContainer

+ (instancetype)defaultDatabase;

- (void)save;
- (void)saveContext:(NSManagedObjectContext *)context;

- (void)fetchAllAppModelsWithCompletion:(void(^)(NSArray <RJTApplicationModel *> *allModels))completion;
- (void)fetchAllAppEntitiesWithCompletion:(void(^)(NSArray <RJTApplicationEntity *> *allEntities))completion;

- (void)fetchAppModelsWithPredicate:(NSPredicate *)predicate completion:(void(^)(NSArray <RJTApplicationModel *> *models))completion;
- (void)fetchAppEntitiesWithPredicate:(NSPredicate *)predicate completion:(void (^)(NSArray<RJTApplicationEntity *> *entities))completion;

- (void)insertAppModels:(NSArray <RJTApplicationModel *> *)appModels completion:(void(^ _Nullable)(void))completion;

- (void)updateModel:(RJTApplicationModel *)appModel;

- (void)removeModel:(RJTApplicationModel *)appModel completion:(void(^ _Nullable)(NSError * _Nullable error))completion;
@end

NS_ASSUME_NONNULL_END

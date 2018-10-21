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

- (void)fetchAppModelsWithPredicate:(NSPredicate *)predicate completion:(void(^)(NSArray <RJTApplicationModel *>  * _Nonnull models))completion;
@end

NS_ASSUME_NONNULL_END

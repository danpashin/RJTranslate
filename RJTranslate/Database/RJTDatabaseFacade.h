//
//  RJTDatabaseFacade.h
//  RJTranslate
//
//  Created by Даниил on 07/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RJTApplicationEntity;
@class RJTDatabase;

NS_ASSUME_NONNULL_BEGIN

@interface RJTDatabaseFacade : NSObject

/**
 База данных.
 */
@property (strong, nonatomic, readonly) RJTDatabase *database;

/**
 Выполняет асинхронную загрузку сущностей из базы данных.
 
 @param predicate Предикат, по которому осуществляется выборка. Может быть nil.
 @param completion Блок, который вызывается по завершении операции. Содержит массив доступных сущностей.
 */
- (void)fetchAppEntitiesWithPredicate:(NSPredicate * _Nullable)predicate
                           completion:(void (^)(NSArray <RJTApplicationEntity *> *entities))completion;

/**
 Выполняет полное обнуление базы данных.

 @param completion Блок, который вызывается по завершении операции.
 */
- (void)purgeWithCompletion:(void(^_Nullable)(void))completion;

/**
 Принудительно выполняет сохранение базы в постоянное хранилище.
 */
- (void)forceSaveContext;

@end

NS_ASSUME_NONNULL_END

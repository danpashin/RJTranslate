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

+ (instancetype _Nullable)defaultDatabase;

/**
 Выполняет асинхронную загрузку из базы данных все доступные модели приложений.

 @param completion Блок, который вызывается по завершении операции.
 */
- (void)fetchAllAppModelsWithCompletion:(void(^)(NSArray <RJTApplicationModel *> *allModels))completion;

/**
 Выполняет асинхронную загрузку моделей из базы данных.

 @param predicate Предикат, по которому осуществляется выборка. Может быть nil.
 @param completion Блок, который вызывается по завершении операции. Содержит массив доступных моделей.
 */
- (void)fetchAppModelsWithPredicate:(NSPredicate * _Nullable)predicate
                         completion:(void(^)(NSArray <RJTApplicationModel *> *models))completion;

/**
 Выполняет асинхронную загрузку сущностей из базы данных.
 
 @param predicate Предикат, по которому осуществляется выборка. Может быть nil.
 @param completion Блок, который вызывается по завершении операции. Содержит массив доступных сущностей.
 */
- (void)fetchAppEntitiesWithPredicate:(NSPredicate * _Nullable)predicate
                           completion:(void (^)(NSArray <RJTApplicationEntity *> *entities))completion;


/**
 Осуществляет добавление моделей в базу.

 @param appModels Массив моделей для добавления.
 @param completion Блок, который вызывается по завершении операции.
 */
- (void)insertAppModels:(NSArray <RJTApplicationModel *> *)appModels completion:(void(^ _Nullable)(void))completion;

/**
 Обновляет параметры модели в базе данных.

 @param appModel Модель, которую необходимо обновить.
 */
- (void)updateModel:(RJTApplicationModel *)appModel;

/**
 Выполняет удаление модели из базы.

 @param appModel Модель, которую необходимо удалить.
 @param completion Блок, который вызывается по завершении операции. Если операция неудачна, содержит ошибку с детальной информацией.
 */
- (void)removeModel:(RJTApplicationModel *)appModel completion:(void(^ _Nullable)(NSError * _Nullable error))completion;
@end

NS_ASSUME_NONNULL_END

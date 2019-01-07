//
//  RJTDatabaseFacade.h
//  RJTranslate
//
//  Created by Даниил on 07/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RJTApplicationModel, RJTApplicationEntity;

NS_ASSUME_NONNULL_BEGIN

@interface RJTDatabaseFacade : NSObject

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



/**
 Выполняет поиск модел(и/ей) по базе.
 
 @param text Текст, по которому необходимо искать
 @param completion  Блок, который вызывается по завершении операции. Содержит массив найденных моделей.
 */
- (void)performModelsSearchWithText:(NSString *)text
                         completion:(void(^)(NSArray<RJTApplicationModel *> * _Nonnull models))completion;

/**
 Выполняет полное обновление моделей в базе.
 
 @param models Массив актуальных моделей. Если модель есть в базе, но нет в массиве, выполняет удаление модели из базы.
 @param completion Блок, который вызывается по завершении операции.
 */
- (void)performFullDatabaseUpdateWithModels:(NSArray <RJTApplicationModel *> *)models
                                 completion:(void(^ _Nullable)(void))completion;


@end

NS_ASSUME_NONNULL_END

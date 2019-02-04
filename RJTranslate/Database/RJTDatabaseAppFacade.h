//
//  RJTDatabaseAppFacade.h
//  RJTranslate
//
//  Created by Даниил on 04/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

#import "RJTDatabaseFacade.h"
@class TranslationModel;

NS_ASSUME_NONNULL_BEGIN

@interface RJTDatabaseAppFacade : RJTDatabaseFacade

/**
 Выполняет асинхронную загрузку из базы данных все доступные модели приложений.
 
 @param completion Блок, который вызывается по завершении операции.
 */
- (void)fetchAllAppModelsWithCompletion:(void(^)(NSArray <TranslationModel *> *allModels))completion;

/**
 Выполняет асинхронную загрузку моделей из базы данных.
 
 @param predicate Предикат, по которому осуществляется выборка. Может быть nil.
 @param completion Блок, который вызывается по завершении операции. Содержит массив доступных моделей.
 */
- (void)fetchAppModelsWithPredicate:(NSPredicate * _Nullable)predicate
                         completion:(void(^)(NSArray <TranslationModel *> *models))completion;

/**
 Обновляет параметры модели в базе данных.
 
 @param appModel Модель, которую необходимо обновить.
 */
- (void)updateModel:(TranslationModel *)appModel;

/**
 Выполняет удаление модели из базы.
 
 @param appModel Модель, которую необходимо удалить.
 @param completion Блок, который вызывается по завершении операции. Если операция неудачна, содержит ошибку с детальной информацией.
 */
- (void)removeModel:(TranslationModel *)appModel completion:(void(^ _Nullable)(NSError * _Nullable error))completion;

- (void)addAppModels:(NSArray <TranslationModel *> *)appModels completion:(void(^_Nullable)(void))completion;


/**
 Выполняет поиск модел(и/ей) по базе.
 
 @param text Текст, по которому необходимо искать
 @param completion  Блок, который вызывается по завершении операции. Содержит массив найденных моделей.
 */
- (void)performModelsSearchWithText:(NSString *)text
                         completion:(void(^)(NSArray<TranslationModel *> * _Nonnull models))completion;

@end

NS_ASSUME_NONNULL_END

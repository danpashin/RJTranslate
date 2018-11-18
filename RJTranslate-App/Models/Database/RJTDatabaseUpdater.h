//
//  RJTDatabaseUpdater.h
//  RJTranslate-App
//
//  Created by Даниил on 23/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RJTDatabase, RJTDatabaseUpdater, RJTApplicationModel, RJTDatabaseUpdate;

NS_ASSUME_NONNULL_BEGIN

@protocol RJTDatabaseUpdaterDelegate <NSObject>

@required

/**
 Метод вызывается, когда апдейтер закончил обрабатывать модели приложений.

 @param databaseUpdater Экземляр апдейтера.
 @param models Массив с обработанными моделями приложений.
 */
- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater finishedUpdateWithModels:(NSArray <RJTApplicationModel *> *)models;

/**
 Метод вызывается, когда апдейтер терпит неудачу. Это может быть как ошибка при загрузку локализаций, так и ошибка их обработки.

 @param databaseUpdater Экземляр апдейтера.
 @param error Ошибка, которая произошла в процессе.
 */
- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater failedUpdateWithError:(NSError *)error;

/**
 Метод вызывается, когда апдейтер начинает обновлять базу данных.

 @param databaseUpdater Экземляр апдейтера.
 */
- (void)databaseUpdaterDidStartUpdatingDatabase:(RJTDatabaseUpdater *)databaseUpdater;

@optional

/**
 Метод вызывется, когда апдейтер обновляет прогресс обработки.

 @param databaseUpdater Экземпляр апдейтера.
 @param progress Текущий прогресс обработки.
 */
- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater updateProgress:(double)progress;

@end



@interface RJTDatabaseUpdater : NSObject

/**
 Выполняет инициализацию апдейтера.

 @param delegate Делегат для объекта-обработчика статуса обновления.
 @return Возвращает экземпляр класса для дальнейшей работы.
 */
- (instancetype)initWithDelegate:(id<RJTDatabaseUpdaterDelegate>)delegate;

/**
 Делегат для объекта-обработчика статуса обновления.
 */
@property (weak, nonatomic, nullable, readonly) id <RJTDatabaseUpdaterDelegate> delegate;

/**
 Выполняет загрузку и последующую обработку моделей приложений.
 */
- (void)performDatabaseUpdate;

/**
 Проверяет версию локализации приложений.

 @param completion Блок вызывается в конце проверки.
 */
- (void)checkTranslationsVersion:(void(^)(RJTDatabaseUpdate * _Nullable updateModel, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END

//
//  RJTCollectionViewModel.h
//  RJTranslate-App
//
//  Created by Даниил on 11/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RJTDatabase, RJTAppCollectionView, RJTApplicationModel;
@class RJTCollectionViewDataSource;

NS_ASSUME_NONNULL_BEGIN

@interface RJTCollectionViewModel : NSObject

/**
 Модел датасорс коллекции.
 */
@property (strong, nonatomic, readonly) RJTCollectionViewDataSource *currentDataSource;

/**
 Выполняет инициализацию модели для конкретной коллекции.

 @param collectionView Коллекция, для которой выполняется инициализация модели.
 @return Возвращает экземпляр класса для дальнейшей работы.
 */
- (instancetype)initWithCollectionView:(RJTAppCollectionView *)collectionView;

/**
 Подготавливает коллекцию к выполнению поиска. Метод должен вызываться всегда перед началом поиска.
 */
- (void)beginSearch;

/**
 Выполняет поиск в базе данных по заданному тексту и перезагружает коллекцию.

 @param text Текст, по которому выполняется поиск.
 */
- (void)performSearchWithText:(NSString *)text;

/**
 Заканчивает выполнение поиска и сбрасывает коллекцию к тому состоянию, в котором она была перед началом поиска.
 */
- (void)endSearch;

/**
 Выполняет полную перезагрузку коллекции из базы данных.
 */
- (void)loadDatabaseModels;

/**
 Выполняет обновление модели в базе данных.

 @param appModel Модель для обновления.
 */
- (void)updateModel:(RJTApplicationModel *)appModel;

@end

NS_ASSUME_NONNULL_END

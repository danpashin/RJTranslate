//
//  RJTCollectionViewDataSource.h
//  RJTranslate-App
//
//  Created by Даниил on 08/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RJTApplicationModel;

NS_ASSUME_NONNULL_BEGIN

@interface RJTCollectionViewDataSource : NSObject

/**
 Массив содержит модели переводов, приложения которых установлены на устройстве.
 */
@property (nonatomic, readonly) NSArray <RJTApplicationModel *> *installedAppsModels;

/**
 Массив содержит модели переводов, приложения которых НЕ установлены на устройстве.
 */
@property (nonatomic, readonly) NSArray <RJTApplicationModel *> *uninstalledAppsModels;


/**
 Выполняет инициализацию и разделение моделей в датасорсе.

 @param appModels Модели для датасорса.
 @return Возвращает экземпляр класса для дальнейшей работы.
 */
- (instancetype)initWithModels:(NSArray<RJTApplicationModel *> *)appModels NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

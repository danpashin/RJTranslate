//
//  RJTAppIcon.h
//  RJTranslate
//
//  Created by Даниил on 31/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RJTAppIconEntity.h"
@class RJTApplicationModel;

NS_ASSUME_NONNULL_BEGIN

@interface RJTAppIcon : NSObject

/**
 Выполняет парсинг модели из словаря.
 
 @param dictionary Словарь для парсинга.
 @param appModel Модель приложения, к которой привязана модель иконки. Используется для получения саймо иконки приложения.
 @return Возвращает экземпляр класса для дальнейшей работы.
 */
+ (RJTAppIcon *)from:(NSDictionary * _Nullable)dictionary appModel:(RJTApplicationModel * _Nullable)appModel;

/**
 Выполняет инициализацию модели через сущность базы данных.

 @param entity Сущность базы данных для инициализации.
 @param appModel  Модель приложения, к которой привязана модель иконки. Используется для получения саймо иконки приложения.
 @return Возвращает экземпляр класса для дальнейшей работы.
 */
+ (RJTAppIcon *)copyFromEntity:(RJTAppIconEntity *)entity appModel:(RJTApplicationModel * _Nullable)appModel;

/**
 Путь к изображению в файловой системе.
 */
@property (strong, nonatomic, nullable, readonly) NSString *path;

/**
 Изображение в формате base64.
 */
@property (strong, nonatomic, nullable, readonly) NSString *base64_encoded;

/**
 Выполняет загрузку изображения из кэша, файла или base64.

 @param completion Блок, вызывающийся при завершении. Всегда вызывется на фоновой очереди.
 */
- (void)loadIconWithCompletion:(void(^)(UIImage * _Nullable iconImage))completion;

@end

NS_ASSUME_NONNULL_END

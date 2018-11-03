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
 Выполняет инициализацию модели через сущность базы данных.

 @param entity Сущность базы данных для инициализации.
 @param appModel  Модель приложения, к которой привязана модель иконки. Используется для получения саймо иконки приложения.
 @return Возвращает экземпляр класса для дальнейшей работы.
 */
+ (RJTAppIcon *)copyFromEntity:(RJTAppIconEntity *)entity appModel:(RJTApplicationModel * _Nullable)appModel;

/**
 Выполняет парсинг модели из словаря.

 @param dictionary Словарь для парсинга.
 @param appModel Модель приложения, к которой привязана модель иконки. Используется для получения саймо иконки приложения.
 @return Возвращает экземпляр класса для дальнейшей работы.
 */
+ (RJTAppIcon *)from:(NSDictionary *)dictionary appModel:(RJTApplicationModel * _Nullable)appModel;

/**
 Путь к изображению в файловой системе.
 */
@property (strong, nonatomic, nullable, readonly) NSString *path;

/**
 Изображение в формате base64.
 */
@property (strong, nonatomic, nullable, readonly) NSString *base64_encoded;

/**
 Создает изображение из доступных данных: файла либо base64 строке. Не потокобезопасно.
 */
@property (strong, nonatomic, readonly, nullable) UIImage *image;

@end

NS_ASSUME_NONNULL_END

//
//  RJTApplicationModel.h
//  RJTranslate-App
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RJTAppIcon.h"
@class RJTApplicationEntity;

NS_ASSUME_NONNULL_BEGIN

@interface RJTApplicationModel : NSObject

/**
 Выполняет инициализацию модели из сущности базы данных.

 @param entity Сущность базы данных для копирования.
 @return Возвращает экземпляр класса для дальнейшей работы.
 */
+ (RJTApplicationModel *)copyFromEntity:(RJTApplicationEntity *)entity;

/**
 Выполняет парсинг модели из словаря.

 @param dictionary Словарь для парсинга.
 @return  Возвращает экземпляр класса для дальнейшей работы. Может вернуть nil, если парсинг прошел неуспешно.
 */
+ (RJTApplicationModel * _Nullable)from:(NSDictionary *)dictionary;

/**
 Отображаемое пользователю имя приложения.
 */
@property (strong, nonatomic, readonly, nullable) NSString *displayedName;

/**
 Уникальный идентификатор бандла приложения.
 */
@property (strong, nonatomic, readonly, nullable) NSString *bundleIdentifier;

/**
 Имя выполняемого файла приложения.
 */
@property (strong, nonatomic, readonly, nullable) NSString *executableName;

/**
 Полный путь в бинарному файлу приложения.
 */
@property (strong, nonatomic, readonly, nullable) NSString *executablePath;

/**
 Словарь с переводами строк.
 */
@property (strong, nonatomic, readonly, nullable) NSDictionary *translation;

/**
 Модель иконки приложения.
 */
@property (strong, nonatomic, readonly, nullable) RJTAppIcon *icon;

/**
 Флаг определяет, должен ли перевод быть включен. Определяется самим пользователем.
 */
@property (assign, nonatomic) BOOL enableTranslation;

/**
 Флаг определяет, должен ли выполняться принудительный перевод приложения.
 */
@property (assign, nonatomic, readonly) BOOL forceLocalize;

@end

NS_ASSUME_NONNULL_END

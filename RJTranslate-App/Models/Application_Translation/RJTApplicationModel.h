//
//  RJTApplicationModel.h
//  RJTranslate-App
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class RJTApplicationEntity;

NS_ASSUME_NONNULL_BEGIN

@interface RJTApplicationModel : NSObject

/**
 Выполняет инициализацию модели из сущности базы данных.

 @param entity Сущность базы данных для копирования.
 @return Возвращает экземпляр класса для дальнейшей работы.
 */
+ (instancetype)copyFromEntity:(RJTApplicationEntity *)entity;

+ (instancetype)copyFromEntity:(RJTApplicationEntity *)entity lightweight:(BOOL)lightweight;

/**
 Выполняет парсинг модели из словаря.

 @param dictionary Словарь для парсинга.
 @return  Возвращает экземпляр класса для дальнейшей работы. Может вернуть nil, если парсинг прошел неуспешно.
 */
+ (instancetype _Nullable)from:(NSDictionary *)dictionary;

/**
 Отображаемое пользователю имя приложения.
 */
@property (strong, nonatomic, readonly) NSString *displayedName;

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

@property (strong, nonatomic, readonly, nullable) NSString *iconPath;

/**
 Флаг определяет, должен ли перевод быть включен. Определяется самим пользователем.
 */
@property (assign, nonatomic) BOOL enableTranslation;

/**
 Флаг определяет, должен ли выполняться принудительный перевод приложения.
 */
@property (assign, nonatomic, readonly) BOOL forceLocalize;

/**
 Флаг определяет, существует ли приложение в файловой системе.
 */
@property (assign, nonatomic, readonly) BOOL appInstalled;


@property (assign, nonatomic, readonly) BOOL lightweightModel;

@property (strong, nonatomic, readonly) NSDate *updateDate;

@end

NS_ASSUME_NONNULL_END

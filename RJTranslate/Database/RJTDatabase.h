//
//  RJTDatabase.h
//  RJTranslate
//
//  Created by Даниил on 19/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;

NS_ASSUME_NONNULL_BEGIN

@interface RJTDatabase : NSObject

/**
 Загружает базу данных и локальное хранилище.

 @return Возвращает экземпляр класса для работы с базой.
 */
+ (instancetype _Nullable)defaultDatabase;

/**
 Флаг определяет, может ли в базу данных вестись запись.
 */
@property (assign, nonatomic, readonly) BOOL readOnly;

/**
 Выполняет сохранение главного контекста в постоянное хранилище.
 */
- (void)saveContext;

/**
 Выполняет указанный блок в фоновом режиме.

 @param block Блок для выполнения.
 */
- (void)performBackgroundTask:(void (^)(NSManagedObjectContext * _Nonnull))block;

@end

NS_ASSUME_NONNULL_END

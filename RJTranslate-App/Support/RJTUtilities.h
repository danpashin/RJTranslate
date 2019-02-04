//
//  RJTUtilities.h
//  RJTranslate-App
//
//  Created by Даниил on 04/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJTUtilities : NSObject

/**
 Выполняет системную команду.
 
 @param command Набор аргументов (вместе с полным путем) для исполнения.
 */
+ (void)executeSystemCommand:(NSArray <NSString *> *)command;

/**
 Вызывает селектор на объекте, используя несколько аргументов
 
 @param selector Селектор для вызова.
 @param target Цель (объект) для вызова селектора.
 @return Возвращает nil или любое значение, возвращенное функцией объекта.
 */
+ (nullable void *)invokeSelector:(SEL)selector onTarget:(id)target;

/**
 Вызывает селектор на объекте, используя несколько аргументов
 
 @param selector Селектор для вызова.
 @param target Цель (объект) для вызова селектора.
 @param firstArgument Набор передаваемых аргументов.
 @return Возвращает nil или любое значение, возвращенное функцией объекта.
 */
+ (nullable void *)invokeSelector:(SEL)selector onTarget:(id)target arguments:(nullable id)firstArgument, ... NS_REQUIRES_NIL_TERMINATION;

@end

NS_ASSUME_NONNULL_END

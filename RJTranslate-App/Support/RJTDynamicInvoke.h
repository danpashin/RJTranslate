//
//  RJTDynamicInvoke.h
//  RJTranslate-App
//
//  Created by Даниил on 30/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJTDynamicInvoke : NSObject

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
+ (nullable void *)invokeSelector:(SEL)selector onTarget:(id)target arguments:(nullable id)firstArgument, ...;

@end

NS_ASSUME_NONNULL_END

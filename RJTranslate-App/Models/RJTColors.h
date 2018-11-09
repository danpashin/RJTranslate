//
//  RJTColors.h
//  RJTranslate-App
//
//  Created by Даниил on 24/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/NSObject.h>
@class UIColor;

NS_ASSUME_NONNULL_BEGIN

@interface RJTColors : NSObject

/**
 Основной цвет приложения.
 */
@property (strong, nonatomic, class, readonly) UIColor *accentMainColor;

/**
 Дополнительный цвет приложения.
 */
@property (strong, nonatomic, class, readonly) UIColor *accentSecondaryColor;

/**
 Оттенок бара навигации.
 */
@property (strong, nonatomic, class, readonly) UIColor *navTintColor;

/**
 Цвет текста заголовков.
 */
@property (strong, nonatomic, class, readonly) UIColor *headerColor;

/**
 Цвет основных подписей.
 */
@property (strong, nonatomic, class, readonly) UIColor *textPrimaryColor;

/**
 Цвет детальных подписей.
 */
@property (strong, nonatomic, class, readonly) UIColor *textDetailColor;

@end

NS_ASSUME_NONNULL_END

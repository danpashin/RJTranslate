//
//  RJTColors.h
//  RJTranslate-App
//
//  Created by Даниил on 24/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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

@end

NS_ASSUME_NONNULL_END

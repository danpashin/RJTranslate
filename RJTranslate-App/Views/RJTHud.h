//
//  RJTHud.h
//  RJTranslate
//
//  Created by Даниил on 28/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface RJTHud : UIView

+ (instancetype)show;

/**
 По умолчанию, 0.75
 */
@property (assign, nonatomic) CGFloat progress;
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@property (strong, nonatomic, nullable) NSString *text;
@property (strong, nonatomic, nullable) NSString *detailText;

/**
 Стиль заднего размытия. По умолчанию, UIBlurEffectStyleLight
 */
@property (assign, nonatomic) UIBlurEffectStyle blurStyle;

- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;
- (void)hideAfterDelay:(CGFloat)delay;

@end

NS_ASSUME_NONNULL_END

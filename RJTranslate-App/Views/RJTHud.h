//
//  RJTHud.h
//  RJTranslate
//
//  Created by Даниил on 28/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Определяет стиль индикатора.

 - RJTHudStyleSpinner: Показывает спиннер и текст (если есть).
 - RJTHudStyleTextOnly: Показывает только текст.
 */
typedef NS_ENUM(NSInteger, RJTHudStyle) {
    RJTHudStyleSpinner = 0,
    RJTHudStyleTextOnly
};


@interface RJTHud : UIView

/**
 Выполняет показ индикатора на видимом окне UIWindow.

 @return Возвращает экземпляр индикатора для дальнейшей настройки.
 */
+ (instancetype)show;


/**
 @brief Устанавливает прогресс спиннера
 
 @discussion По умолчанию, установлен на 0.75.
 */
@property (assign, nonatomic) CGFloat progress;

/**
 Устанавливает прогресс спиннера.

 @param progress Значение прогресса от 0 до 1
 @param animated Если задан YES, то прогресс будет установлен с анимацией. В противном случае - без.
 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

/**
 Устанавливает стиль индикатора.
 */
@property (readwrite, assign, nonatomic) RJTHudStyle style;

/**
 Устанавливает основной текст в индикатор.
 Для скрытия должен быть установлен в nil.
 */
@property (readwrite, copy, nonatomic, nullable) NSString *text;

/**
 Устанавливает дополнительный текст в индикатор.
 Для скрытия должен быть установлен в nil.
 */
@property (readwrite, copy, nonatomic, nullable) NSString *detailText;

/**
 Стиль заднего размытия. По умолчанию, UIBlurEffectStyleLight
 */
@property (assign, nonatomic) UIBlurEffectStyle blurStyle;

/**
 Выполняет показ индикатора на окне.

 @param animated Если флаг установлен в YES, выполняется с анимацией. В противном случае - без.
 */
- (void)showAnimated:(BOOL)animated;

/**
 Выполняет скрытие индикатора с окна.

 @param animated Если флаг установлен в YES, выполняется с анимацией. В противном случае - без.
 */
- (void)hideAnimated:(BOOL)animated;

/**
 Выполняет анимированное скрытие индикатора с задержкой.

 @param delay Задержка скрытия.
 
 @see '-hideAnimated:'
 */
- (void)hideAfterDelay:(CGFloat)delay;

@end

NS_ASSUME_NONNULL_END

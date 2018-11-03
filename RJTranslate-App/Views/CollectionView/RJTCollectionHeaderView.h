//
//  RJTCollectionHeaderView.h
//  RJTranslate-App
//
//  Created by Даниил on 26/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJTCollectionHeaderView : UIView

/**
 Основной лейбл хэдера.
 */
@property (strong, nonatomic, readonly) UILabel *textLabel;

/**
 Дополнительный лейбл.
 */
@property (strong, nonatomic, readonly) UILabel *detailedTextLabel;

@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;

/**
 Обновляет положение хэдера на экране.

 @param show Флаг определяет появление/скрытие на экране
 @param animated Флаг определяет, должна ли воспроизводиться анимация.
 */
- (void)show:(BOOL)show animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

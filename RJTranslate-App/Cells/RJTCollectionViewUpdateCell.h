//
//  RJTCollectionViewUpdateCell.h
//  RJTranslate-App
//
//  Created by Даниил on 07/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJTCollectionViewUpdateCell : UICollectionViewCell

/**
 Основной лейбл хэдера.
 */
@property (strong, nonatomic, readonly) UILabel *textLabel;

/**
 Дополнительный лейбл.
 */
@property (strong, nonatomic, readonly) UILabel *detailedTextLabel;

@end

NS_ASSUME_NONNULL_END

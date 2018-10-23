//
//  RJTAppCell.h
//  RJTranslate-App
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RJTApplicationModel;

NS_ASSUME_NONNULL_BEGIN

@interface RJTAppCell : UICollectionViewCell

@property (strong, nonatomic, nullable) RJTApplicationModel *model;

- (void)updateSelection:(BOOL)selected animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

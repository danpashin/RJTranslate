//
//  RJTSwitchCell.h
//  RJTranslate-App
//
//  Created by Даниил on 13/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RJTPrefsOption;

NS_ASSUME_NONNULL_BEGIN

@interface RJTSwitchCell : UITableViewCell

@property (weak, nonatomic) RJTPrefsOption *model;

@end

NS_ASSUME_NONNULL_END

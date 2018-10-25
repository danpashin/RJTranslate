//
//  RJTTickView.h
//  RJTTools
//
//  Created by Даниил on 24/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJTTickView : UIView

@property (assign, nonatomic) IBInspectable BOOL enabled;

- (void)setEnabled:(BOOL)enabled animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END

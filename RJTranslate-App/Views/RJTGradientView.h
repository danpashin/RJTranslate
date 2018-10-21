//
//  RJTGradientView.h
//  RJTranslate
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJTGradientView : UIView

@property (nonatomic, readonly, class) RJTGradientView *defaultGradientView;

@property (nonatomic, readonly, strong) CAGradientLayer *layer;

@end

NS_ASSUME_NONNULL_END

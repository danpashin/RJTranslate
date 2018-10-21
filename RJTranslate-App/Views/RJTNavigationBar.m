//
//  RJTNavigationBar.m
//  RJTranslate-App
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTNavigationBar.h"
#import "RJTGradientView.h"

@interface RJTNavigationBar ()
@property (strong, nonatomic) RJTGradientView *gradientView;
@end

@interface UINavigationBar ()
@property(retain, nonatomic, setter=_setBackgroundView:) UIView *_backgroundView;
@end

@implementation RJTNavigationBar

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.tintColor = [UIColor whiteColor];    
    [UIVisualEffectView appearanceWhenContainedInInstancesOfClasses:@[self.class]].hidden = YES;
    
    self.gradientView = [RJTGradientView defaultGradientView];
    [self._backgroundView addSubview:self.gradientView];
    
    self.gradientView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.gradientView.topAnchor constraintEqualToAnchor:self._backgroundView.topAnchor].active = YES;
    [self.gradientView.bottomAnchor constraintEqualToAnchor:self._backgroundView.bottomAnchor].active = YES;
    [self.gradientView.leadingAnchor constraintEqualToAnchor:self._backgroundView.leadingAnchor].active = YES;
    [self.gradientView.trailingAnchor constraintEqualToAnchor:self._backgroundView.trailingAnchor].active = YES;
}

@end

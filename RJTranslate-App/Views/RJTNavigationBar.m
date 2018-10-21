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

@implementation RJTNavigationBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIColor *mainColor = [UIColor colorWithRed:43.0f/255.0f green:49.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
    UIColor *secondaryColor = [UIColor colorWithRed:82.0f/255.0f green:104.0f/255.0f blue:118.0f/255.0f alpha:1.0f];


    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage new]];
    self.tintColor = [UIColor whiteColor];
    
    self.gradientView = [RJTGradientView new];
    self.gradientView.layer.colors = @[(id)secondaryColor.CGColor, (id)mainColor.CGColor];
    self.gradientView.layer.startPoint = CGPointMake(0.0f, 0.0f);
    self.gradientView.layer.endPoint = CGPointMake(1.0f, 1.0f);
    [self addSubview:self.gradientView];
    
    self.gradientView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.gradientView.topAnchor constraintEqualToAnchor:self.topAnchor constant:-20.0f].active = YES;
    [self.gradientView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.gradientView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self.gradientView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
}

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    [self sendSubviewToBack:self.gradientView];
}

@end

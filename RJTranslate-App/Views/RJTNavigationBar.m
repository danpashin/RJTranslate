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

    self.tintColor = RJTColors.navTintColor;
    self.shadowImage = [UIImage new];
}

@end

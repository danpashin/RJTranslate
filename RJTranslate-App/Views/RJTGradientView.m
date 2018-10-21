//
//  RJTGradientView.m
//  RJTranslate
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTGradientView.h"

@implementation RJTGradientView
@dynamic layer;

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

+ (RJTGradientView *)defaultGradientView
{
    UIColor *mainColor = [UIColor colorWithRed:43.0f/255.0f green:49.0f/255.0f blue:75.0f/255.0f alpha:1.0f];
    UIColor *secondaryColor = [UIColor colorWithRed:82.0f/255.0f green:104.0f/255.0f blue:118.0f/255.0f alpha:1.0f];
    
    RJTGradientView *gradientView = [RJTGradientView new];
    gradientView.layer.colors = @[(id)secondaryColor.CGColor, (id)mainColor.CGColor];
    gradientView.layer.startPoint = CGPointMake(0.0f, 0.0f);
    gradientView.layer.endPoint = CGPointMake(1.0f, 1.0f);
    
    return gradientView;
}

@end

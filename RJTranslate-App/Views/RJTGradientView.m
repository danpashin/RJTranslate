//
//  RJTGradientView.m
//  RJTranslate
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTGradientView.h"
#import "RJTColors.h"

@implementation RJTGradientView
@dynamic layer;

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

+ (RJTGradientView *)defaultGradientView
{
    RJTGradientView *gradientView = [RJTGradientView new];
    gradientView.layer.colors = @[(id)RJTColors.accentSecondaryColor.CGColor, (id)RJTColors.accentMainColor.CGColor];
    gradientView.layer.startPoint = CGPointMake(0.5, 0.0);
    gradientView.layer.endPoint = CGPointMake(0.5, 1.0);
    
    return gradientView;
}

@end

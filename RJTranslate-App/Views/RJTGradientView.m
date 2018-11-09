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
    gradientView.layer.startPoint = CGPointMake(0.0f, 0.5f);
    gradientView.layer.endPoint = CGPointMake(1.0f, 0.5f);
    
    return gradientView;
}

@end

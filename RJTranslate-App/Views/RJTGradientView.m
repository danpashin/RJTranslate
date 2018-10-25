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
    gradientView.layer.colors = @[(id)[RJTColors secondaryColor].CGColor, (id)[RJTColors mainColor].CGColor];
    gradientView.layer.startPoint = CGPointMake(0.0f, 0.0f);
    gradientView.layer.endPoint = CGPointMake(1.0f, 1.0f);
    
    return gradientView;
}

@end

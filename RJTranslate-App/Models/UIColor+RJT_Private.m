//
//  UIColor+RJT_Private.m
//  RJTranslate-App
//
//  Created by Даниил on 11/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "UIColor+RJT_Private.h"

@implementation UIColor (RJT_Private)

- (UIColor *)darkerColor
{
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return self;
}

@end

//
//  RJTColors.m
//  RJTranslate-App
//
//  Created by Даниил on 24/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTColors.h"
#import <UIKit/UIKit.h>

@implementation RJTColors

+ (UIColor *)accentMainColor
{
    return [UIColor colorWithRed:95/255.0f green:111/255.0f blue:237/255.0f alpha:1.0f];
}

+ (UIColor *)accentSecondaryColor
{
    return [UIColor colorWithRed:117/255.0f green:133/255.0f blue:220/255.0f alpha:1.0f];
}

+ (UIColor *)headerColor
{
    return [UIColor colorWithWhite:0.1f alpha:1.0f];
}

+ (UIColor *)navTintColor
{
    return [UIColor colorWithWhite:0.1f alpha:1.0f];
}

+ (UIColor *)textPrimaryColor
{
    return [UIColor colorWithWhite:0.05f alpha:1.0f];
}

+ (UIColor *)textDetailColor
{
    return [UIColor colorWithWhite:0.83f alpha:1.0f];
}

@end

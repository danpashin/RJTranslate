//
//  UINavigationBar+RJTExtended.m
//  RJTranslate-App
//
//  Created by Даниил on 04/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

#import "UINavigationBar+RJTExtended.h"

@interface UINavigationBar (RJT_Private)
- (void)_setHidesShadow:(_Bool)arg1;
- (_Bool)_hidesShadow;
@end

@implementation UINavigationBar (RJTExtended)

BOOL _shadowHidden = NO;

- (BOOL)rjt_hideShadow
{
    return _shadowHidden;
}

- (void)setRjt_hideShadow:(BOOL)rjt_hideShadow
{
    _shadowHidden = YES;
    
    self.shadowImage = rjt_hideShadow ? [UIImage new] : nil;
    [self _setHidesShadow:rjt_hideShadow];
}

@end

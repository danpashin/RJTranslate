//
//  Swizzling.m
//  RJTranslate-App
//
//  Created by Даниил on 20/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>

@interface _UINavigationControllerManagedSearchPalette : UIView
- (void)_setShadowAlpha:(double)alpha;
@end

CHDeclareClass(_UINavigationControllerManagedSearchPalette);
CHDeclareMethod(1, void, _UINavigationControllerManagedSearchPalette, _setShadowAlpha, double, _shadowAlpha)
{
    CHSuper(1, _UINavigationControllerManagedSearchPalette, _setShadowAlpha, 0.3);
}

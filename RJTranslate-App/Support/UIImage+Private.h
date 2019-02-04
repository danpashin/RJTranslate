//
//  UIImage+Private.h
//  RJTranslate
//
//  Created by Даниил on 30/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIImage, NSString;

typedef NS_ENUM(NSUInteger, MIIconVariant) {
        // iphone  ipad
    MIIconVariantSmall,            // 29x29   29x29
    MIIconVariantSpotlight,        // 40x40   40x40
    MIIconVariantDefault,          // 62x62   78x78
    MIIconVariantGameCenter,       // 42x42   78x78
    MIIconVariantDocumentFull,     // 37x48   37x48
    MIIconVariantDocumentSmall,    // 37x48   37z48
    MIIconVariantSquareBig,        // 82x82   128x128
    MIIconVariantSquareDefault,    // 62x62   78x78
    MIIconVariantTiny,             // 20x20   20x20
    MIIconVariantDocument,         // 37x48   247x320
    MIIconVariantDocumentLarge,    // 37x48   247x320
    MIIconVariantUnknownGradient,  // 300x150 300x150
    MIIconVariantSquareGameCenter, // 42x42   42x42
    MIIconVariantUnknownDefault,   // 62x62   78x78
};


@interface UIImage (Private)
+ (instancetype)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(MIIconVariant)format scale:(CGFloat)scale;
@end

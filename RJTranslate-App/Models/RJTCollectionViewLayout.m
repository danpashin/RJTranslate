//
//  RJTCollectionViewLayout.m
//  RJTranslate-App
//
//  Created by Даниил on 21/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTCollectionViewLayout.h"

@implementation RJTCollectionViewLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), 72.0f);
}

- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    attributes.transform = CGAffineTransformMakeScale(0.2f, 0.2f);

    return attributes;
}

- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    attributes.transform = CGAffineTransformMakeScale(0.2f, 0.2f);

    return attributes;
}

@end

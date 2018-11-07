//
//  RJTCollectionViewLayout.m
//  RJTranslate-App
//
//  Created by Даниил on 21/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTCollectionViewLayout.h"

@interface RJTCollectionViewLayout ()
@property (strong, nonatomic) NSArray *collectionViewOldDataSource;
@property (weak, nonatomic) NSArray *collectionViewNewDataSource;
@end

@implementation RJTCollectionViewLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 20.0f, 0.0f);
    self.itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame) - 24.0f, 72.0f);
}

- (void)finalizeCollectionViewUpdates
{
    [super finalizeCollectionViewUpdates];
    self.collectionViewOldDataSource = nil;
}

- (void)dataSourceChangedFrom:(NSArray *)oldDataSource toNew:(NSArray *)newDatasource
{
    self.collectionViewOldDataSource = oldDataSource;
    self.collectionViewNewDataSource = newDatasource;
}


#pragma mark -

- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    NSInteger oldItemsCount = (NSInteger)(self.collectionViewOldDataSource.count);
    if (self.collectionViewOldDataSource && itemIndexPath.item > oldItemsCount - 1)
        attributes.transform = CGAffineTransformMakeScale(0.2f, 0.2f);

    return attributes;
}

- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    NSInteger newItemsCount = (NSInteger)(self.collectionViewNewDataSource.count);
    if (itemIndexPath.item > newItemsCount - 1)
        attributes.transform = CGAffineTransformMakeScale(0.2f, 0.2f);

    return attributes;
}


@end

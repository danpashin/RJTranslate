//
//  RJTCollectionViewLayout.m
//  RJTranslate-App
//
//  Created by Даниил on 21/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTCollectionViewLayout.h"
#import "RJTCollectionViewDataSource.h"

@interface RJTCollectionViewLayout ()
@property (strong, nonatomic) RJTCollectionViewDataSource *collectionViewOldDataSource;
@property (weak, nonatomic) RJTCollectionViewDataSource *collectionViewNewDataSource;
@end

@implementation RJTCollectionViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 20.0f, 0.0f);
    }
    return self;
}

- (CGSize)itemSizeFromCollectionFrame:(CGRect)collectionViewFrame
{
    return CGSizeMake(CGRectGetWidth(collectionViewFrame) - 24.0f, AppCell.defaultHeight);
}

- (void)finalizeCollectionViewUpdates
{
    [super finalizeCollectionViewUpdates];
    self.collectionViewOldDataSource = nil;
}

- (void)dataSourceChangedFrom:(RJTCollectionViewDataSource *)oldDataSource toNew:(RJTCollectionViewDataSource *)newDatasource
{
    self.collectionViewOldDataSource = oldDataSource;
    self.collectionViewNewDataSource = newDatasource;
}


#pragma mark -

- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    NSInteger oldItemsCount = 0;
    if (itemIndexPath.section == 1)
        oldItemsCount = self.collectionViewOldDataSource.installedAppsModels.count;
    else if (itemIndexPath.section == 2)
        oldItemsCount = self.collectionViewOldDataSource.uninstalledAppsModels.count;
    
    if (self.collectionViewOldDataSource && itemIndexPath.item > oldItemsCount - 1)
        attributes.transform = CGAffineTransformMakeScale(0.2f, 0.2f);

    return attributes;
}

- (nullable UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    NSInteger newItemsCount = 0;
    if (itemIndexPath.section == 1) {
        newItemsCount = self.collectionViewOldDataSource.installedAppsModels.count;
//        RJTLog(@"section 1: %@", @(newItemsCount));
    } else if (itemIndexPath.section == 2) {
        newItemsCount = self.collectionViewOldDataSource.uninstalledAppsModels.count;
//        RJTLog(@"section 2: %@", @(newItemsCount));
    }
    
    if (itemIndexPath.item > newItemsCount - 1)
        attributes.transform = CGAffineTransformMakeScale(0.2f, 0.2f);

    return attributes;
}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    return YES;
//}

@end

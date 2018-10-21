//
//  RJTAppCollectionView.m
//  RJTranslate-App
//
//  Created by Даниил on 21/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTAppCollectionView.h"
#import "RJTApplicationModel.h"

#import "RJTAppCell.h"

@interface RJTAppCollectionView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@end

@implementation RJTAppCollectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.availableApps = [NSMutableArray array];
    self.searchResults = [NSMutableArray array];
    
    self.dataSource = self;
    self.delegate = self;
    self.alwaysBounceVertical = YES;
    
    UICollectionViewFlowLayout *collectionLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    collectionLayout.itemSize = CGSizeMake(CGRectGetWidth(self.frame) - 48.0f, 72.0f);
    collectionLayout.sectionInset = UIEdgeInsetsMake(20.0f, 0.0f, 20.0f, 0.0f);
}

- (void)reloadData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [super reloadData];
    });
}

//- (void)reloadDataAnimated
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSArray *dataSource = self.performingSearch ? self.searchResults : self.availableApps;
//        for (id object in <#collection#>) {
//            <#statements#>
//        }
//    });
//}

#pragma mark -
#pragma mark UICollectionViewDataSource
#pragma mark -

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.performingSearch ? self.searchResults.count : self.availableApps.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    RJTAppCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                 forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(nonnull RJTAppCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    cell.model = self.performingSearch ? self.searchResults[indexPath.row] : self.availableApps[indexPath.row];
}

@end

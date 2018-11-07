//
//  RJTAppCollectionViewDelegate.m
//  RJTranslate-App
//
//  Created by Даниил on 07/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTAppCollectionViewDelegate.h"
#import "RJTApplicationModel.h"
#import "RJTCollectionViewLayout.h"

#import "RJTCollectionViewUpdateCell.h"
#import "RJTCollectionLabelHeader.h"
#import "RJTAppCell.h"

@interface RJTAppCollectionView ()
- (void)sendSelectionFeedback;
@end


@implementation RJTAppCollectionViewDelegate

- (instancetype)initWithCollectionView:(RJTAppCollectionView *)collectionView
{
    self = [super init];
    if (self) {
        _collectionView = collectionView;
        collectionView.delegate = self;
        collectionView.dataSource = self;
    }
    
    return self;
}

- (void)appCell:(RJTAppCell *)appCell setSelected:(BOOL)selected
{
    [appCell updateSelection:selected animated:YES];
    
    appCell.model.enableTranslation = selected;
    [self.collectionView.customDelegate collectionView:self.collectionView didUpdateModel:appCell.model];
    [self.collectionView sendSelectionFeedback];
}


#pragma mark -
#pragma mark UICollectionViewDataSource
#pragma mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
        return (NSInteger)self.showUpdateHeader;
    
    return self.collectionView.appModels.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        RJTCollectionViewUpdateCell *updateCell = (RJTCollectionViewUpdateCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"updateCell"
                                                                                                                           forIndexPath:indexPath];
        
        if ([self.collectionView.customDelegate respondsToSelector:@selector(collectionView:didLoadUpdateCell:)])
            [self.collectionView.customDelegate collectionView:self.collectionView didLoadUpdateCell:updateCell];
        
        return updateCell;
    }
    
    
    RJTAppCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"appCell"
                                                                 forIndexPath:indexPath];
    cell.model = self.collectionView.appModels[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[RJTAppCell class]]) {
        RJTAppCell *appCell = (RJTAppCell *)cell;
        
        if (appCell.model.enableTranslation) {
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [appCell updateSelection:YES animated:NO];
            appCell.selected = YES;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[RJTAppCell class]]) {
        [self appCell:(RJTAppCell *)cell setSelected:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RJTAppCell *cell = (RJTAppCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[RJTAppCell class]]) {
        [self appCell:(RJTAppCell *)cell setSelected:NO];
    }
}

- (UICollectionReusableView * _Nonnull)collectionView:(UICollectionView *)collectionView
                    viewForSupplementaryElementOfKind:(NSString *)kind
                                          atIndexPath:(NSIndexPath *)indexPath
{
    RJTCollectionLabelHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                              withReuseIdentifier:@"header"
                                                                                     forIndexPath:indexPath];
    if (indexPath.section == 1) {
        headerView.label.text = NSLocalizedString(@"installed", @"");
    } else {
        headerView.label.text = @"test";
    }
    
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(RJTCollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 44.0f);
    }
    
    return CGSizeZero;
}


@end

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
#import "RJTCollectionViewDataSource.h"

#import "RJTCollectionViewUpdateCell.h"
#import "RJTCollectionLabelHeader.h"
#import "RJTAppCell.h"

@interface RJTAppCollectionView ()
@property (strong, nonatomic) RJTCollectionViewDataSource *modelsSourceObject;
@end


@implementation RJTAppCollectionViewDelegate

- (instancetype)initWithCollectionView:(RJTAppCollectionView *)collectionView
{
    self = [super init];
    if (self) {
        _collectionView = collectionView;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        [collectionView registerClass:[RJTCollectionLabelHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    
    return self;
}

- (void)appCell:(RJTAppCell *)appCell setSelected:(BOOL)selected
{
    [appCell updateSelection:selected animated:YES];
    
    appCell.model.enableTranslation = selected;
    [self.collectionView.customDelegate collectionView:self.collectionView didUpdateModel:appCell.model];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UISelectionFeedbackGenerator *selectionGenerator = [UISelectionFeedbackGenerator new];
        [selectionGenerator prepare];
        [selectionGenerator selectionChanged];
    });
}


#pragma mark -
#pragma mark UICollectionViewDataSource
#pragma mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
        return (NSInteger)self.showUpdateHeader;
    
    if (section == 1)
        return self.collectionView.modelsSourceObject.installedAppsModels.count;

    if (section == 2)
        return self.collectionView.modelsSourceObject.uninstalledAppsModels.count;
    
    return 0;
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
    if (indexPath.section == 1)
        cell.model = self.collectionView.modelsSourceObject.installedAppsModels[indexPath.row];
    else if (indexPath.section == 2)
        cell.model = self.collectionView.modelsSourceObject.uninstalledAppsModels[indexPath.row];
    
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
    }
    
    return headerView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(RJTCollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    RJTCollectionViewDataSource *dataSource = self.collectionView.modelsSourceObject;
    if (section == 1 && dataSource.installedAppsModels.count > 0) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 52.0f);
    }
    
    if (section == 2 && dataSource.installedAppsModels.count > 0 && dataSource.uninstalledAppsModels.count > 0) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), 16.0f);
    }
    
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(RJTCollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0 && self.showUpdateHeader)
        return UIEdgeInsetsMake(10.0, 0.0f, 0.0, 0.0f);
    
    RJTCollectionViewDataSource *dataSource = self.collectionView.modelsSourceObject;
    if ((section == 1 && dataSource.installedAppsModels.count > 0) || section == 2) {
        return UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 0.0f);
    } else if (section == 1 || section == 2)
        return UIEdgeInsetsMake(0.0f, 0.0f, 10.0f, 0.0f);
    
    return UIEdgeInsetsZero;
}


@end

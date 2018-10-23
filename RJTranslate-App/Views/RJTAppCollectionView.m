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
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface RJTAppCollectionView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@end

@implementation RJTAppCollectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.availableApps = [NSArray array];
    self.searchResults = [NSArray array];
    
    self.dataSource = self;
    self.delegate = self;
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    self.alwaysBounceVertical = YES;
    self.allowsMultipleSelection = YES;
    
    UICollectionViewFlowLayout *collectionLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    collectionLayout.itemSize = CGSizeMake(CGRectGetWidth(self.frame) - 48.0f, 72.0f);
    collectionLayout.sectionInset = UIEdgeInsetsMake(20.0f, 0.0f, 20.0f, 0.0f);
}

- (void)reload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [self reloadEmptyDataSet];
    });
}

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
    cell.model = self.performingSearch ? self.searchResults[indexPath.row] : self.availableApps[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(RJTAppCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (cell.model.enableTranslation) {
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [cell updateSelection:YES animated:NO];
        cell.selected = YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RJTAppCell *cell = (RJTAppCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell updateSelection:YES animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RJTAppCell *cell = (RJTAppCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell updateSelection:NO animated:YES];
}



#pragma mark -
#pragma mark DZNEmptyDataSetSource
#pragma mark -

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (!self.performingSearch)
        return [UIImage imageNamed:@"translationIcon"];
    else if (self.performingSearch && self.searchText.length > 0)
        return [UIImage imageNamed:@"sad-face"];
    
    return nil;
}

- (UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor colorWithRed:82.0f/255.0f green:104.0f/255.0f blue:118.0f/255.0f alpha:1.0f];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *titleString = @"";
    
    if (self.performingSearch && self.searchText.length > 0)
        titleString = @"К сожалению, по вашему запросу ничего не найдено.";
    else if (!self.performingSearch)
        titleString = @"Нет установленных переводов. Нажмите на кнопку ниже, чтобы загрузить доступные.";
    
    return [[NSAttributedString alloc] initWithString:titleString
                                           attributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2]}];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    if (self.performingSearch)
        return nil;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2],
                                 NSForegroundColorAttributeName: [UIColor colorWithWhite:0.2f alpha:1.0f]};
    
    return [[NSAttributedString alloc] initWithString:@"Скачать" attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -50.0f;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    if (!self.performingSearch)
        [self.customDelegate collectionViewRequestedDownloadingTranslations:self];
}

@end

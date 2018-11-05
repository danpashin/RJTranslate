//
//  RJTAppCollectionView.m
//  RJTranslate-App
//
//  Created by Даниил on 21/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTAppCollectionView.h"

#import "RJTApplicationModel.h"
#import "RJTCollectionViewLayout.h"

#import "RJTAppCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "RJTSearchController.h"

@interface RJTAppCollectionView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) RJTCollectionViewLayout *collectionViewLayout;
@end

@implementation RJTAppCollectionView
@dynamic collectionViewLayout;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.dataSource = self;
    self.delegate = self;
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    self.alwaysBounceVertical = YES;
    self.allowsMultipleSelection = YES;
}

- (void)setAppModels:(NSArray<RJTApplicationModel *> *)appModels
{
    [self performOnMainThread:^{
        [self.collectionViewLayout dataSourceChangedFrom:self->_appModels toNew:appModels];
    }];
    
    _appModels = appModels;
}

- (void)reload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [self reloadEmptyDataSet];
    });
}

- (void)sendSelectionFeedback
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UISelectionFeedbackGenerator *selectionGenerator = [UISelectionFeedbackGenerator new];
        [selectionGenerator prepare];
        [selectionGenerator selectionChanged];
    });
}

- (void)performOnMainThread:(void(^)(void))block
{
    [NSThread isMainThread] ? block() : dispatch_sync(dispatch_get_main_queue(), block);
}

#pragma mark -
#pragma mark UICollectionViewDataSource
#pragma mark -

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.appModels.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    RJTAppCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                 forIndexPath:indexPath];
    cell.model = self.appModels[indexPath.row];
    
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
    
    cell.model.enableTranslation = YES;
    [self.customDelegate collectionView:self didUpdateModel:cell.model];
    [self sendSelectionFeedback];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RJTAppCell *cell = (RJTAppCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell updateSelection:NO animated:YES];
    
    cell.model.enableTranslation = NO;
    [self.customDelegate collectionView:self didUpdateModel:cell.model];
    [self sendSelectionFeedback];
}



#pragma mark -
#pragma mark DZNEmptyDataSetSource
#pragma mark -

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    RJTSearchController *searchController = self.searchController;
    if (!searchController.performingSearch)
        return [UIImage imageNamed:@"translationIcon"];
    else if (searchController.performingSearch && searchController.searchText.length > 0)
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
    
    RJTSearchController *searchController = self.searchController;
    if (searchController.performingSearch && searchController.searchText.length > 0)
        titleString = NSLocalizedString(@"cannot_find_any_results", @"");
    else if (!searchController.performingSearch)
        titleString = NSLocalizedString(@"no_translations_downloaded", @"");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2],
                                 NSForegroundColorAttributeName: [UIColor grayColor]};
    
    return [[NSAttributedString alloc] initWithString:titleString attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *titleString = @"";
    
    RJTSearchController *searchController = self.searchController;
    if (searchController.performingSearch && searchController.searchText.length > 0)
        titleString = NSLocalizedString(@"change_search_request_and_try_again", @"");
    else if (!searchController.performingSearch)
        titleString = NSLocalizedString(@"tap_button_to_download_available", @"");
    
    return [[NSAttributedString alloc] initWithString:titleString];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    if (self.searchController.performingSearch)
        return nil;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3],
                                 NSForegroundColorAttributeName: [UIColor colorWithWhite:0.2f alpha:1.0f]};
    
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"download", @"") attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -50.0f;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    if (!self.searchController.performingSearch)
        [self.customDelegate collectionViewRequestedDownloadingTranslations:self];
}

@end

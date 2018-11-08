//
//  RJTAppCollectionView.m
//  RJTranslate-App
//
//  Created by Даниил on 21/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTAppCollectionViewDelegate.h"
#import "RJTApplicationModel.h"
#import "RJTCollectionViewLayout.h"
#import "RJTCollectionViewDataSource.h"

#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "RJTSearchController.h"

#import "RJTCollectionLabelHeader.h"


@interface RJTAppCollectionView () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) RJTCollectionViewLayout *collectionViewLayout;
@property (strong, nonatomic) RJTAppCollectionViewDelegate *delegateObject;
@property (strong, nonatomic) RJTCollectionViewDataSource *modelsSourceObject;
@end

@implementation RJTAppCollectionView
@dynamic collectionViewLayout;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    self.alwaysBounceVertical = YES;
    self.allowsMultipleSelection = YES;
    
    [self registerClass:[RJTCollectionLabelHeader class]
forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    self.modelsSourceObject = [RJTCollectionViewDataSource new];
    self.delegateObject = [[RJTAppCollectionViewDelegate alloc] initWithCollectionView:self];
}

- (void)updateViewWithModelsAndReload:(NSArray<RJTApplicationModel *> *)appModels
{
    @synchronized (self) {
        RJTCollectionViewDataSource *modelsSourceObject = [RJTCollectionViewDataSource new];
        [appModels enumerateObjectsUsingBlock:^(RJTApplicationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.executableExists) {
                [modelsSourceObject.installedAppsModels addObject:obj];
            } else {
                [modelsSourceObject.uninstalledAppsModels addObject:obj];
            }
        }];
        
        [self performOnMainThread:^{
            [self.collectionViewLayout dataSourceChangedFrom:self.modelsSourceObject toNew:modelsSourceObject];
            self.modelsSourceObject = modelsSourceObject;
            [self reload];
        }];
    }
}

- (void)reload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
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

- (void)showUpdateCell:(BOOL)shouldShow
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.delegateObject.showUpdateHeader = shouldShow;
        [self reload];
    });
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

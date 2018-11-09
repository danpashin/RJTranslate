//
//  RJTCollectionViewEmptyDataSource.m
//  RJTranslate-App
//
//  Created by Даниил on 09/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTCollectionViewEmptyDataSource.h"
#import "RJTSearchController.h"

#import "RJTGradientView.h"
#import "RJTAppCollectionView.h"

@implementation RJTCollectionViewEmptyDataSource

- (instancetype)initWithCollectionView:(RJTAppCollectionView *)collectionView
{
    self = [super init];
    if (self) {
        _collectionView = collectionView;
        collectionView.emptyDataSetSource = self;
        collectionView.emptyDataSetDelegate = self;
    }
    return self;
}

#pragma mark -
#pragma mark DZNEmptyDataSetSource
#pragma mark -

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    RJTSearchController *searchController = self.collectionView.searchController;
    if (!searchController.performingSearch)
        return [UIImage imageNamed:@"translationIcon"];
    else if (searchController.performingSearch && searchController.searchText.length > 0)
        return [UIImage imageNamed:@"sad-face"];
    
    return nil;
}

- (UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor colorWithRed:149/255.0f green:132/255.0f blue:156/255.0f alpha:1.0f];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *titleString = @"";
    
    RJTSearchController *searchController = self.collectionView.searchController;
    if (searchController.performingSearch && searchController.searchText.length > 0)
        titleString = NSLocalizedString(@"cannot_find_any_results", @"");
    else if (!searchController.performingSearch)
        titleString = NSLocalizedString(@"no_translations_downloaded", @"");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:[UIFont labelFontSize] * 1.5f],
                                 NSForegroundColorAttributeName: RJTColors.headerColor};
    
    return [[NSAttributedString alloc] initWithString:titleString attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *titleString = @"";
    
    RJTSearchController *searchController = self.collectionView.searchController;
    if (searchController.performingSearch && searchController.searchText.length > 0)
        titleString = NSLocalizedString(@"change_search_request_and_try_again", @"");
    else if (!searchController.performingSearch)
        titleString = NSLocalizedString(@"tap_button_to_download_available", @"");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:[UIFont labelFontSize]],
                                 NSForegroundColorAttributeName: [UIColor grayColor]};
    return [[NSAttributedString alloc] initWithString:titleString attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    if (self.collectionView.searchController.performingSearch)
        return nil;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"download", @"") attributes:attributes];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    __block UIImage *image = nil;
    void (^renderBlock)(void) = ^{
        CGSize imageSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 44.0);
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        RJTGradientView *gradientView = [RJTGradientView defaultGradientView];
        gradientView.frame = (CGRect){{0, 0}, imageSize};
        gradientView.layer.cornerRadius = 10.0;
        [gradientView.layer renderInContext:context];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    };
    
    [NSThread isMainThread] ? renderBlock() : dispatch_sync(dispatch_get_main_queue(), renderBlock);
    
    return image;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -50.0f;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 16.0f;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    if (!self.collectionView.searchController.performingSearch)
        [self.collectionView.customDelegate collectionViewRequestedDownloadingTranslations:self.collectionView];
}

@end

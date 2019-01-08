//
//  RJTCollectionViewEmptyDataSource.m
//  RJTranslate-App
//
//  Created by Даниил on 09/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTCollectionViewEmptyDataSource.h"
//#import "RJTSearchController.h"

#import "RJTGradientView.h"
#import "RJTAppCollectionView.h"

#import "UIColor+RJT_Private.h"

@interface RJTCollectionViewEmptyDataSource ()
@property (strong, nonatomic) UIImage *buttonNormalImage;
@property (strong, nonatomic) UIImage *buttonSelectedImage;
@end

@implementation RJTCollectionViewEmptyDataSource

- (instancetype)initWithCollectionView:(RJTAppCollectionView *)collectionView
{
    self = [super init];
    if (self) {
        _collectionView = collectionView;
        collectionView.emptyDataSetSource = self;
        collectionView.emptyDataSetDelegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    self.buttonNormalImage = nil;
    self.buttonSelectedImage = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIImage *)buttonNormalImage
{
    if (!_buttonNormalImage) {
        _buttonNormalImage = [self renderButtonImageForState:UIControlStateNormal];
    }
    return _buttonNormalImage;
}

- (UIImage *)buttonSelectedImage
{
    if (!_buttonSelectedImage) {
        _buttonSelectedImage = [self renderButtonImageForState:UIControlStateHighlighted];
    }
    return _buttonSelectedImage;
}

- (UIImage *)renderButtonImageForState:(UIControlState)state
{
    __block UIImage *image = nil;
    void (^renderBlock)(void) = ^{
        CGSize imageSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 44.0);
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        RJTGradientView *gradientView = [RJTGradientView defaultGradientView];
        gradientView.frame = (CGRect){{0, 0}, imageSize};
        gradientView.layer.cornerRadius = 10.0;
        
        if (state == UIControlStateHighlighted) {
            NSMutableArray *newColors = [NSMutableArray array];
            for (id color in gradientView.layer.colors) {
                UIColor *uiColor = [UIColor colorWithCGColor:(__bridge CGColorRef)color];
                [newColors addObject:(id)uiColor.darkerColor.CGColor];
            }
            gradientView.layer.colors = newColors;
        }
        
        [gradientView.layer renderInContext:context];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    };
    
    [NSThread isMainThread] ? renderBlock() : dispatch_sync(dispatch_get_main_queue(), renderBlock);
    
    return image;
}

#pragma mark -
#pragma mark DZNEmptyDataSetSource
#pragma mark -

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.type == EmptyViewTypeNoData)
        return [UIImage imageNamed:@"translationIcon"];
    
    return nil;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *titleString = @"";
    
    if (self.type == EmptyViewTypeNoSearchResults)
        titleString = NSLocalizedString(@"cannot_find_any_results", @"");
    else if (self.type == EmptyViewTypeNoData)
        titleString = NSLocalizedString(@"no_translations_downloaded", @"");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:[UIFont labelFontSize] * 1.5f],
                                 NSForegroundColorAttributeName: RJTColors.headerColor};
    
    return [[NSAttributedString alloc] initWithString:titleString attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *titleString = @"";
    
    if (self.type == EmptyViewTypeNoSearchResults)
        titleString = NSLocalizedString(@"change_search_request_and_try_again", @"");
    else if (self.type == EmptyViewTypeNoData)
        titleString = NSLocalizedString(@"tap_button_to_download_available", @"");
    else if (self.type == EmptyViewTypeLoading)
        titleString = NSLocalizedString(@"loading_data...", @"");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:[UIFont labelFontSize]],
                                 NSForegroundColorAttributeName: [UIColor grayColor]};
    return [[NSAttributedString alloc] initWithString:titleString attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    if (self.type != EmptyViewTypeNoData)
        return nil;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"download", @"") attributes:attributes];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return (state == UIControlStateNormal) ? self.buttonNormalImage : self.buttonSelectedImage;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 16.0f;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    if (self.type == EmptyViewTypeNoData)
        [self.collectionView.customDelegate collectionViewRequestedDownloadingTranslations:self.collectionView];
}

@end

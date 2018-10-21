//
//  RJTSearchController.m
//  RJTranslate-App
//
//  Created by Даниил on 21/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTSearchController.h"

@interface RJTSearchController ()

@end

@interface UISearchBar (RJT_Private)
@property (readonly, strong) UITextField *searchField;
@end

@implementation RJTSearchController

- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController
{
    self = [super initWithSearchResultsController:searchResultsController];
    if (self) {
        self.dimsBackgroundDuringPresentation = NO;
        self.hidesNavigationBarDuringPresentation = NO;
        self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        self.dimsBackgroundDuringPresentation = NO;
        
        self.searchBar.searchField.layer.cornerRadius = 18.0f;
        self.searchBar.searchField.layer.masksToBounds = YES;
        self.searchBar.searchField.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setDimBackground:(BOOL)dimBackground
{
    if (_dimBackground == dimBackground)
        return;
    
    _dimBackground = dimBackground;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.15f delay:0.0f options:0 animations:^{
            self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:dimBackground ? 0.35f : 0.0f];
        } completion:nil];
    });
}

@end

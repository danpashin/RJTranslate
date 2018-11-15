//
//  RJTSearchController.m
//  RJTranslate-App
//
//  Created by Даниил on 21/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTSearchController.h"

@interface RJTSearchController () <UISearchBarDelegate>

@end

@interface UISearchBar (RJT_Private)
@property (readonly, strong) UITextField *searchField;
@end

@implementation RJTSearchController
@synthesize searchText = _searchText;

- (instancetype)initWithDelegate:(id<UISearchControllerDelegate>)delegate
            searchResultsUpdater:(id<UISearchResultsUpdating>)searchResultsUpdater
{
    self = [super initWithSearchResultsController:nil];
    if (self) {
        _dimBackground = YES;
        self.delegate = delegate;
        self.searchResultsUpdater = searchResultsUpdater;
        
        self.dimsBackgroundDuringPresentation = NO;
        self.searchBar.delegate = self;
        
        if (@available(iOS 11.0, *)) {
        } else {
            self.hidesNavigationBarDuringPresentation = NO;
            
            self.searchBar.searchField.layer.cornerRadius = 8.0f;
            self.searchBar.searchField.layer.masksToBounds = YES;
            self.searchBar.searchField.backgroundColor = [UIColor colorWithRed:0.0f green:0.027f blue:0.098f alpha:0.08f];
        }
    }
    
    return self;
}

- (NSString *)searchText
{
    if (!_searchText)
        _searchText = @"";
    
    return _searchText;
}

- (void)showDimmingView:(BOOL)show
{
    if (!self.dimBackground)
        return;
    
    [UIView animateWithDuration:0.15f delay:0.0f options:0 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:show ? 0.3f : 0.0f];
    } completion:nil];
}


#pragma mark -
#pragma mark UISearchBarDelegate
#pragma mark -

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _performingSearch = YES;
    [self showDimmingView:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [[UIApplication sharedApplication].appDelegate.tracker trackSearchEvent:self.searchText];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _searchText = searchText;
    
    [self showDimmingView:(searchText.length == 0)];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _searchText = nil;
    _performingSearch = NO;
    [self showDimmingView:NO];
}

@end

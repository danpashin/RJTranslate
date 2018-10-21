//
//  RJTranslateController.m
//  RJTranslate
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTranslateController.h"
#import "RJTSearchController.h"
#import "RJTNavigationController.h"

#import "RJTDatabase.h"

#import "RJTAppCollectionView.h"

@interface RJTranslateController () <UISearchResultsUpdating, UISearchControllerDelegate, RJTAppCollectionViewDelegate>

@property (strong, nonatomic) RJTDatabase *localDatabase;
@property (strong, nonatomic) NSOperation *searchOperation;

@property (weak, nonatomic) IBOutlet RJTAppCollectionView *collectionView;
@property (strong, nonatomic) RJTSearchController *searchController;
@property (nullable, nonatomic,readonly,strong) RJTNavigationController *navigationController;

@end

@implementation RJTranslateController
@dynamic navigationController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.customDelegate = self;
    
    self.localDatabase = [RJTDatabase defaultDatabase];
    [self.localDatabase fetchAllAppModelsWithCompletion:^(NSArray<RJTApplicationModel *> * _Nonnull allModels) {
        self.collectionView.availableApps = allModels;
        [self.collectionView reloadData];
    }];
    
    self.searchController = [[RJTSearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    
    self.navigationItem.titleView = self.searchController.searchBar;
}


#pragma mark -
#pragma mark UISearchResultsUpdating, UISearchControllerDelegate 
#pragma mark -

- (void)updateSearchResultsForSearchController:(RJTSearchController *)searchController
{
    searchController.dimBackground = (searchController.searchBar.text.length == 0);
    
    if (self.searchOperation)
        [self.searchOperation cancel];
    
    NSString *searchText = searchController.searchBar.text;
    self.searchOperation = [NSBlockOperation blockOperationWithBlock:^{
        self.collectionView.performingSearch = YES;
        self.collectionView.searchText = searchText;
        self.collectionView.searchResults = nil;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bundle_identifier CONTAINS[cd] %@ OR app_name CONTAINS[cd] %@", searchText, searchText];
        [self.localDatabase fetchAppModelsWithPredicate:predicate completion:^(NSArray<RJTApplicationModel *> * _Nonnull models) {
            self.collectionView.searchResults = models;
            [self.collectionView reloadData];
        }];
    }];
    [self.searchOperation start];
}

- (void)willPresentSearchController:(RJTSearchController *)searchController
{
    [self.navigationController showNavigationLargeTitle:NO];
    searchController.dimBackground = YES;
}

- (void)didDismissSearchController:(RJTSearchController *)searchController
{
    [self.navigationController showNavigationLargeTitle:YES];
    searchController.dimBackground = NO;
    
    self.collectionView.performingSearch = NO;
    [self.collectionView reloadData];
}


#pragma mark -
#pragma mark RJTAppCollectionViewDelegate 
#pragma mark -

- (void)collectionViewRequestedDownloadingTranslations:(RJTAppCollectionView *)collectionView
{
    NSLog(@"Should start downloading translations");
}

@end

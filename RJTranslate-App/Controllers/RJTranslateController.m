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
#import "RJTDatabaseUpdater.h"

#import "RJTAppCollectionView.h"

@interface RJTranslateController () <UISearchResultsUpdating, UISearchControllerDelegate, RJTAppCollectionViewDelegate, RJTDatabaseUpdaterDelegate>

@property (strong, nonatomic) RJTDatabase *localDatabase;
@property (strong, nonatomic) NSOperation *searchOperation;
@property (strong, nonatomic) RJTDatabaseUpdater *databaseUpdater;

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
    [self updateAllModels];
    
    self.searchController = [[RJTSearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    
    self.navigationItem.titleView = self.searchController.searchBar;
}

- (void)updateAllModels
{
    [self.localDatabase fetchAllAppModelsWithCompletion:^(NSArray<RJTApplicationModel *> * _Nonnull allModels) {
        self.collectionView.availableApps = allModels;
        [self.collectionView reload];
    }];
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bundleIdentifier CONTAINS[cd] %@ OR displayedName CONTAINS[cd] %@", searchText, searchText];
        [self.localDatabase fetchAppModelsWithPredicate:predicate completion:^(NSArray<RJTApplicationModel *> * _Nonnull models) {
            self.collectionView.searchResults = models;
            [self.collectionView reload];
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
    [self.collectionView reload];
}


#pragma mark -
#pragma mark RJTAppCollectionViewDelegate 
#pragma mark -

- (void)collectionViewRequestedDownloadingTranslations:(RJTAppCollectionView *)collectionView
{
    self.databaseUpdater = [RJTDatabaseUpdater new];
    self.databaseUpdater.delegate = self;
    [self.databaseUpdater updateDatabase];
}

- (void)collectionView:(RJTAppCollectionView *)collectionView didSelectedModel:(RJTApplicationModel *)appModel
{
    [self.localDatabase updateModel:appModel];
}


#pragma mark -
#pragma mark RJTDatabaseUpdaterDelegate
#pragma mark -

- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater finishedWithModelsArray:(NSArray <RJTApplicationModel *> *)modelsArray
{
    self.databaseUpdater = nil;
    
    [self.localDatabase insertAppModels:modelsArray completion:^{
        [self updateAllModels];
    }];
}

- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater failedWithError:(NSError *)error
{
    RJTErrorLog(@"Failed to update database with error: %@", error);
}

- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater updateProgress:(double)progress
{
    double percent = ceil(progress * 100.0f);
    RJTLog(@"Updating... %.0f%%", percent);
}

@end

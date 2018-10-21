//
//  RJTranslateController.m
//  RJTranslate
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTranslateController.h"

#import "RJTDatabase.h"
#import "RJTApplicationEntity.h"
#import "RJTApplicationModel.h"

#import "RJTAppCollectionView.h"
#import "RJTSearchController.h"

@interface RJTranslateController () <UISearchResultsUpdating, UISearchControllerDelegate, RJTAppCollectionViewDelegate>

@property (strong, nonatomic) RJTDatabase *localDatabase;

@property (weak, nonatomic) IBOutlet RJTAppCollectionView *collectionView;
@property (strong, nonatomic) RJTSearchController *searchController;
@property (strong, nonatomic) NSOperation *searchOperation;

@end

@implementation RJTranslateController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.customDelegate = self;
    
    self.localDatabase = [RJTDatabase defaultDatabase];
    [self.localDatabase performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
        
        NSFetchRequest *fetchAvailable = [RJTApplicationEntity fetchRequest];
        NSArray <RJTApplicationEntity *> *result = [context executeFetchRequest:fetchAvailable error:nil];
        for (RJTApplicationEntity *appEntity in result) {
            [self.collectionView.availableApps addObject:[RJTApplicationModel from:appEntity]];
        }
        [self.collectionView reloadData];
    }];
    
    self.searchController = [[RJTSearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    
    self.navigationItem.titleView = self.searchController.searchBar;
}

- (void)showLargeTitle:(BOOL)show
{
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = show ? UINavigationItemLargeTitleDisplayModeAlways : UINavigationItemLargeTitleDisplayModeNever;
        [self.navigationController.navigationBar setNeedsLayout];
        [self.view setNeedsLayout];
        [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            [self.navigationController.navigationBar layoutIfNeeded];
            [self.view layoutIfNeeded];
        } completion:nil];
    }
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
        [self.collectionView.searchResults removeAllObjects];
        
        [self.localDatabase performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
            NSFetchRequest *fetchRequest = [RJTApplicationEntity fetchRequest];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"bundle_identifier CONTAINS[cd] %@ OR app_name CONTAINS[cd] %@", searchText, searchText];
            
            NSArray <RJTApplicationEntity *> *result = [context executeFetchRequest:fetchRequest error:nil];
            for (RJTApplicationEntity *appEntity in result) {
                [self.collectionView.searchResults addObject:[RJTApplicationModel from:appEntity]];
            }
            [self.collectionView reloadData];
        }];
    }];
    [self.searchOperation start];
}

- (void)willPresentSearchController:(RJTSearchController *)searchController
{
    [self showLargeTitle:NO];
    searchController.dimBackground = YES;
}

- (void)didDismissSearchController:(RJTSearchController *)searchController
{
    [self showLargeTitle:YES];
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

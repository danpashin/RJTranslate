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

#import <spawn.h>
#import "RJTDatabase.h"
#import "RJTDatabaseUpdater.h"
#import "RJTDatabaseUpdate.h"
#import "RJTApplicationModel.h"
#import "RJTApplicationEntity.h"

#import "RJTAppCollectionView.h"
#import "RJTCollectionHeaderView.h"
#import "MBProgressHUD.h"
#import "RJTHud.h"


@interface RJTranslateController () <UISearchResultsUpdating, UISearchControllerDelegate, RJTAppCollectionViewDelegate, RJTDatabaseUpdaterDelegate>

@property (strong, nonatomic) RJTDatabase *localDatabase;
@property (strong, nonatomic) NSOperation *searchOperation;
@property (strong, nonatomic) RJTDatabaseUpdater *databaseUpdater;

@property (weak, nonatomic) IBOutlet RJTAppCollectionView *collectionView;
@property (strong, nonatomic) RJTSearchController *searchController;
@property (nullable, nonatomic,readonly,strong) RJTNavigationController *navigationController;

@property (strong, nonatomic) IBOutlet RJTCollectionHeaderView *headerView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraint;
@property (weak, nonatomic) RJTHud *hud;
@end

@implementation RJTranslateController
@dynamic navigationController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"available_translations", @"");
    
    self.collectionView.customDelegate = self;
    self.headerView.heightConstraint = self.headerHeightConstraint;
    self.headerView.textLabel.text = NSLocalizedString(@"translations_update_is_available", @"");
    self.headerView.detailedTextLabel.text = NSLocalizedString(@"tap_to_download", @"");
    [self.headerView hide:NO];
    [self.headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionUpdateDatabase)]];
    
    self.localDatabase = [RJTDatabase defaultDatabase];
    [self updateAllModels];
    
    self.searchController = [[RJTSearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.navigationItem.titleView = self.searchController.searchBar;
    
    self.databaseUpdater = [RJTDatabaseUpdater new];
    self.databaseUpdater.delegate = self;
    [self.databaseUpdater checkTranslationsVersion:^(RJTDatabaseUpdate * _Nullable updateModel, NSError * _Nullable error) {
        if (!error && updateModel.canUpdate)
            [self.headerView show:YES];
    }];
    
}

- (void)updateAllModels
{
    [self.localDatabase fetchAllAppModelsWithCompletion:^(NSArray<RJTApplicationModel *> * _Nonnull allModels) {
        self.collectionView.availableApps = allModels;
        [self.collectionView reload];
    }];
}

- (void)actionUpdateDatabase
{
    RJTHud *hud = [RJTHud show];
    hud.text = NSLocalizedString(@"please_wait", @"");
    hud.detailText = NSLocalizedString(@"updating_database...", @"");
    self.hud = hud;
    
    [self.databaseUpdater downloadTranslations];
}


#pragma mark -
#pragma mark UISearchResultsUpdating, UISearchControllerDelegate 
#pragma mark -

- (void)updateSearchResultsForSearchController:(RJTSearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    searchController.dimBackground = (searchText.length == 0);
    
    if (self.searchOperation)
        [self.searchOperation cancel];
    
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
    [self.headerView hide:YES];
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
    [self actionUpdateDatabase];
}

- (void)collectionView:(RJTAppCollectionView *)collectionView didSelectedModel:(RJTApplicationModel *)appModel
{
    [self.localDatabase updateModel:appModel];
    
    NSString *executableName = appModel.executableName;
    if (executableName.length > 0) {
        char *args[] = {"/usr/bin/killall", "-9", (char *)executableName.UTF8String, NULL};
        posix_spawn(NULL, args[0], NULL, NULL, args, NULL);
    }
}


#pragma mark -
#pragma mark RJTDatabaseUpdaterDelegate
#pragma mark -

- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater finishedUpdateWithModels:(NSArray <RJTApplicationModel *> *)models
{
    for (RJTApplicationModel *model in models) {
        @autoreleasepool {
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bundleIdentifier == %@", model.bundleIdentifier];
            [self.localDatabase fetchAppEntitiesWithPredicate:predicate completion:^(NSArray<RJTApplicationEntity *> * _Nonnull entities) {
                NSInteger entitiesCount = entities.count;
                if (entitiesCount == 0) {
                    [self.localDatabase insertAppModels:@[model] completion:^{
                        dispatch_semaphore_signal(semaphore);
                    }];
                } else if (entitiesCount == 1) {
                    model.enableTranslation = entities.firstObject.enableTranslation;
                    [self.localDatabase updateModel:model];
                    dispatch_semaphore_signal(semaphore);
                } else {
                    RJTErrorLog(@"Can not update localization. Number of localizations with identifier '%@' is more than one.", model.bundleIdentifier);
                    dispatch_semaphore_signal(semaphore);
                }
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    }
    
    [self updateAllModels];
    self.databaseUpdater = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud hideAnimated:YES];
        [self.headerView hide:YES];
    });
}

- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater failedUpdateWithError:(NSError *)error
{
    RJTErrorLog(@"Failed to update database with error: %@", error);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.hud.superview) {
            self.hud.progress = 1.0f;
//            self.hud.mode = MBProgressHUDModeText;
            self.hud.text = @"Не удалось выполнить обновление.";
            self.hud.detailText = error.localizedDescription;
            [self.hud hideAfterDelay:2.0f];
        }
    });
}

- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater updateProgress:(double)progress
{
//    double percent = ceil(progress * 100.0f);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hud.progress = (float)progress;
    });
}

@end

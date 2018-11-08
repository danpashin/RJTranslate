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

#import "RJTAppCollectionView.h"
#import "RJTCollectionViewUpdateCell.h"
#import "RJTHud.h"


@interface RJTranslateController () <UISearchResultsUpdating, UISearchControllerDelegate, RJTAppCollectionViewDelegate, RJTDatabaseUpdaterDelegate>

@property (strong, nonatomic) RJTDatabase *localDatabase;
@property (strong, nonatomic) RJTDatabaseUpdater *databaseUpdater;

@property (weak, nonatomic) IBOutlet RJTAppCollectionView *collectionView;
@property (strong, nonatomic) RJTSearchController *searchController;
@property (nullable, nonatomic, readonly, strong) RJTNavigationController *navigationController;

@property (weak, nonatomic) RJTHud *hud;
@end

@implementation RJTranslateController
@dynamic navigationController;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.localDatabase = [RJTDatabase defaultDatabase];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"available_translations", @"");
    
    self.collectionView.customDelegate = self;
    [self updateAllModels];
    
    self.searchController = [[RJTSearchController alloc] initWithDelegate:self searchResultsUpdater:self];
    self.collectionView.searchController = self.searchController;
    self.navigationItem.titleView = self.searchController.searchBar;
    
    self.databaseUpdater = [[RJTDatabaseUpdater alloc] initWithDelegate:self];
    [self.databaseUpdater checkTranslationsVersion:^(RJTDatabaseUpdate * _Nullable updateModel, NSError * _Nullable error) {
        if (!error && updateModel.canUpdate)
            [self.collectionView showUpdateCell:YES];
    }];
    
//    __block BOOL showCell = YES;
//    [[NSTimer scheduledTimerWithTimeInterval:6.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [self.collectionView showUpdateCell:showCell];
//        showCell = !showCell;
//    }] fire];
}

- (void)updateAllModels
{
    [self.localDatabase fetchAllAppModelsWithCompletion:^(NSArray<RJTApplicationModel *> * _Nonnull allModels) {
        [self.collectionView updateViewWithModelsAndReload:allModels];
    }];
}

- (void)actionUpdateDatabase
{
    RJTHud *hud = [RJTHud show];
    hud.text = NSLocalizedString(@"please_wait", @"");
    hud.detailText = NSLocalizedString(@"downloating_localization...", @"");
    self.hud = hud;
    
    [self.databaseUpdater downloadTranslations];
}


#pragma mark -
#pragma mark UISearchResultsUpdating, UISearchControllerDelegate 
#pragma mark -

- (void)updateSearchResultsForSearchController:(RJTSearchController *)searchController
{
    [self.localDatabase performModelsSearchWithText:searchController.searchText completion:^(NSArray<RJTApplicationModel *> * _Nonnull models) {
        [self.collectionView updateViewWithModelsAndReload:models];
    }];
}

- (void)willPresentSearchController:(RJTSearchController *)searchController
{
    [self.navigationController showNavigationLargeTitle:NO];
}

- (void)didDismissSearchController:(RJTSearchController *)searchController
{
    [self.navigationController showNavigationLargeTitle:YES];
    [self updateAllModels];
}


#pragma mark -
#pragma mark RJTAppCollectionViewDelegate 
#pragma mark -

- (void)collectionViewRequestedDownloadingTranslations:(RJTAppCollectionView *)collectionView
{
    [self actionUpdateDatabase];
}

- (void)collectionView:(RJTAppCollectionView *)collectionView didUpdateModel:(RJTApplicationModel *)appModel
{
    [self.localDatabase updateModel:appModel];
    
    NSString *executableName = appModel.executableName;
    if (executableName.length > 0) {
        char *args[] = {"/usr/bin/killall", "-9", (char *)executableName.UTF8String, NULL};
        posix_spawn(NULL, args[0], NULL, NULL, args, NULL);
    }
}

- (void)collectionView:(RJTAppCollectionView *)collectionView didLoadUpdateCell:(RJTCollectionViewUpdateCell *)updateCell
{
    updateCell.textLabel.text = NSLocalizedString(@"translations_update_is_available", @"");
    updateCell.detailedTextLabel.text = NSLocalizedString(@"tap_to_download", @"");
    [updateCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionUpdateDatabase)]];
}


#pragma mark -
#pragma mark RJTDatabaseUpdaterDelegate
#pragma mark -

- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater finishedUpdateWithModels:(NSArray <RJTApplicationModel *> *)models
{
    self.hud.progress = 0.75f;
    self.hud.detailText = NSLocalizedString(@"updating_database...", @"");
    
    [self.localDatabase performFullDatabaseUpdateWithModels:models completion:^{
        [self updateAllModels];
        
        [self.hud hideAnimated:YES];
        [self.collectionView showUpdateCell:NO];
    }];
}

- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater failedUpdateWithError:(NSError *)error
{
    self.hud.style = RJTHudStyleTextOnly;
    self.hud.text = NSLocalizedString(@"failed_to_update", @"");
    self.hud.detailText = error.localizedDescription;
    [self.hud hideAfterDelay:2.0f];
}

- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater updateProgress:(double)progress
{
    self.hud.progress = (CGFloat)progress;
}

@end

//
//  RJTranslateController.m
//  RJTranslate
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTranslateController.h"
#import "RJTSearchController.h"
#import "RJTPreferencesController.h"

#import "RJTDatabaseUpdate.h"
#import "RJTDatabaseUpdater.h"
#import "RJTCollectionViewModel.h"

#import "RJTAppCollectionView.h"
#import "RJTCollectionViewUpdateCell.h"
#import "RJTHud.h"


@interface RJTranslateController () <RJTSearchControllerDelegate, RJTAppCollectionViewDelegate, RJTDatabaseUpdaterDelegate>

@property (strong, nonatomic) RJTDatabaseUpdater *databaseUpdater;
@property (strong, nonatomic) RJTCollectionViewModel *collectionViewModel;

@property (weak, nonatomic) RJTHud *hud;
@property (strong, nonatomic) RJTSearchController *searchController;
@property (weak, nonatomic) IBOutlet RJTAppCollectionView *collectionView;

@end

@implementation RJTranslateController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"available_translations", @"");
    
    self.searchController = [[RJTSearchController alloc] initWithDelegate:self];
    self.collectionView.searchController = self.searchController;
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
    } else {
        self.navigationItem.titleView = self.searchController.searchBar;
    }
    
    self.databaseUpdater = [[RJTDatabaseUpdater alloc] initWithDelegate:self];
    [self.databaseUpdater checkTranslationsVersion:^(RJTDatabaseUpdate * _Nullable updateModel, NSError * _Nullable error) {
        if (!error && updateModel.canUpdate)
            [self.collectionView showUpdateCell:YES];
    }];
}

- (void)setCollectionView:(RJTAppCollectionView *)collectionView
{
    _collectionView = collectionView;
    
//    self.collectionView.customDelegate = self;
//    self.collectionViewModel = [[RJTCollectionViewModel alloc] initWithCollectionView:collectionView];
//    [self.collectionViewModel loadDatabaseModels];
}

- (void)actionUpdateDatabase
{
    RJTHud *hud = [RJTHud show];
    hud.text = NSLocalizedString(@"please_wait", @"");
    hud.detailText = NSLocalizedString(@"downloating_localization...", @"");
    self.hud = hud;
    
    [self.databaseUpdater performDatabaseUpdate];
}

- (IBAction)actionPresentPreferences
{
    RJTPreferencesController *prefsController = [RJTPreferencesController new];
    [self.navigationController pushViewController:prefsController animated:YES];
}


#pragma mark -
#pragma mark UISearchResultsUpdating, UISearchControllerDelegate 
#pragma mark -

- (void)willPresentSearchController:(RJTSearchController *)searchController
{
    [self.collectionView showUpdateCell:NO];
    [self.collectionViewModel beginSearch];
}

- (void)searchController:(RJTSearchController *)searchController didUpdateSearchText:(NSString *)searchText
{
    RJTLog(@"'%@'", searchText);
    
    [self.collectionViewModel performSearchWithText:searchText];
}

- (void)willDismissSearchController:(RJTSearchController *)searchController
{
    [self.collectionViewModel endSearch];
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
    [self.collectionViewModel updateModel:appModel];
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

- (void)databaseUpdaterDidStartUpdatingDatabase:(RJTDatabaseUpdater *)databaseUpdater
{
    self.hud.progress = 0.75f;
    self.hud.detailText = NSLocalizedString(@"updating_database...", @"");
}

- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater finishedUpdateWithModels:(NSArray <RJTApplicationModel *> *)models
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.hud hideAnimated:YES];
        [self.collectionView showUpdateCell:NO];
        
        [self.collectionViewModel loadDatabaseModels];
    });
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

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

#import "RJTAppCell.h"

@interface RJTranslateController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (strong, nonatomic) RJTDatabase *localDatabase;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray <RJTApplicationModel *> *availableApps;
@end

@implementation RJTranslateController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.availableApps = [NSMutableArray array];
}

UISearchController *searchController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *collectionLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    collectionLayout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame) - 48.0f, 72.0f);
    collectionLayout.sectionInset = UIEdgeInsetsMake(20.0f, 0.0f, 20.0f, 0.0f);
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.localDatabase = [RJTDatabase defaultDatabase];
    [self.localDatabase performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
        context.retainsRegisteredObjects = YES;
        
        NSFetchRequest *fetchAvailable = [RJTApplicationEntity fetchRequest];
        NSArray <RJTApplicationEntity *> *result = [context executeFetchRequest:fetchAvailable error:nil];
        for (RJTApplicationEntity *appEntity in result) {
            [self.availableApps addObject:[RJTApplicationModel from:appEntity]];
        }
    }];
    
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.navigationItem.searchController = searchController;
    
    self.navigationItem.titleView = searchController.searchBar;
    
    searchController.hidesNavigationBarDuringPresentation = NO;
    searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
}


#pragma mark -
#pragma mark UICollectionViewDataSource
#pragma mark -

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.availableApps.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    RJTAppCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                 forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(nonnull RJTAppCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    cell.model = self.availableApps[indexPath.row];
}


@end

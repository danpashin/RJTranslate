//
//  RJTCollectionViewModel.m
//  RJTranslate-App
//
//  Created by Даниил on 11/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTCollectionViewModel.h"

#import "RJTDatabase.h"
#import "RJTApplicationModel.h"
#import "RJTCollectionViewDataSource.h"

#import "RJTAppCollectionView.h"

#import <spawn.h>

@interface RJTAppCollectionView ()
@property (strong, nonatomic) RJTCollectionViewDataSource *modelsSourceObject;
@end

@interface RJTCollectionViewModel ()
@property (strong, nonatomic) RJTDatabase *database;
@property (weak, nonatomic) RJTAppCollectionView *collectionView;

@property (assign, nonatomic) BOOL performingSearch;

@property (strong, nonatomic) RJTCollectionViewDataSource *cachedDataSource;
@end

@implementation RJTCollectionViewModel

- (instancetype)initWithCollectionView:(RJTAppCollectionView *)collectionView
{
    self = [super init];
    if (self) {
        self.database = [RJTDatabase defaultDatabase];
        self.collectionView = collectionView;
    }
    
    return self;
}


#pragma mark -
#pragma mark Search
#pragma mark -

- (void)beginSearch
{
    self.performingSearch = YES;
    self.cachedDataSource = self.collectionView.modelsSourceObject;
}

- (void)performSearchWithText:(NSString *)searchText
{
    if (!self.performingSearch)
        return;
    
    [self.database performModelsSearchWithText:searchText completion:^(NSArray<RJTApplicationModel *> * _Nonnull models) {
        [self.collectionView updateViewWithModelsAndReload:models];
    }];
    
    [[UIApplication sharedApplication].appDelegate.tracker trackSearchEvent:searchText];
}

- (void)endSearch
{
    self.performingSearch = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        RJTCollectionViewDataSource *cachedDataSource = self.cachedDataSource;
        NSArray *models = cachedDataSource.allObjects.allObjects;
        
        [self.collectionView updateViewWithModelsAndReload:models];
        self.cachedDataSource = nil;
    });
}


#pragma mark -

- (void)loadDatabaseModels
{
    [self.database fetchAllAppModelsWithCompletion:^(NSArray<RJTApplicationModel *> * _Nonnull allModels) {
        [self.collectionView updateViewWithModelsAndReload:allModels];
    }];
}

- (void)updateModel:(RJTApplicationModel *)appModel
{
    [self.database updateModel:appModel];
    
    NSString *executableName = appModel.executableName;
    if (executableName.length > 0) {
        char *args[] = {"/usr/bin/killall", "-9", (char *)executableName.UTF8String, NULL};
        posix_spawn(NULL, args[0], NULL, NULL, args, NULL);
    }
    
    [[UIApplication sharedApplication].appDelegate.tracker trackSelectTranslationWithName:appModel.displayedName];
}

@end

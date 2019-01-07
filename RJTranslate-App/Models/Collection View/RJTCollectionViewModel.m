//
//  RJTCollectionViewModel.m
//  RJTranslate-App
//
//  Created by Даниил on 11/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTCollectionViewModel.h"

#import "RJTDatabaseFacade.h"
#import "RJTApplicationModel.h"
#import "RJTCollectionViewDataSource.h"

#import "RJTAppCollectionView.h"
#import "RJTCollectionViewLayout.h"

#import <spawn.h>


@interface RJTAppCollectionView ()
@property (strong, nonatomic, readwrite) RJTCollectionViewModel *model;
@property (nonatomic, strong) RJTCollectionViewLayout *collectionViewLayout;
@end



@interface RJTCollectionViewModel ()
@property (weak, nonatomic) RJTDatabaseFacade *database;
@property (weak, nonatomic) RJTAppCollectionView *collectionView;

@property (strong, nonatomic) RJTCollectionViewDataSource *allModelsDataSource;
@property (strong, nonatomic, readwrite) RJTCollectionViewDataSource *currentDataSource;
@end

@implementation RJTCollectionViewModel

- (instancetype)initWithCollectionView:(RJTAppCollectionView *)collectionView
{
    self = [super init];
    if (self) {
        self.database = [UIApplication sharedApplication].appDelegate.defaultDatabase;
        self.collectionView = collectionView;
        self.collectionView.model = self;
    }
    
    return self;
}


#pragma mark -
#pragma mark Search
#pragma mark -

- (void)beginSearch
{
    [self.collectionView updateEmptyViewToType:RJTEmptyViewTypeNoSearchResults];
    self.allModelsDataSource = self.currentDataSource;
}

- (void)performSearchWithText:(NSString *)searchText
{
    if (searchText.length == 0) {
        [self restoreDatasource];
        return;
    }
    
    [self.database performModelsSearchWithText:searchText completion:^(NSArray<RJTApplicationModel *> * _Nonnull models) {
        [self updateCollectionWithModels:models];
    }];
    
    [[UIApplication sharedApplication].appDelegate.tracker trackSearchEvent:searchText];
}

- (void)restoreDatasource
{
    [self updateDataSourceObject:self.allModelsDataSource];
}

- (void)endSearch
{
    [self restoreDatasource];
    self.allModelsDataSource = nil;
}


#pragma mark -

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


#pragma mark -

- (void)loadDatabaseModels
{
    [self.collectionView updateEmptyViewToType:RJTEmptyViewTypeLoading];
    [self.database fetchAllAppModelsWithCompletion:^(NSArray<RJTApplicationModel *> * _Nonnull allModels) {
        if (allModels.count == 0)
            [self.collectionView updateEmptyViewToType:RJTEmptyViewTypeNoData animated:YES];
        
        [self updateCollectionWithModels:allModels]; 
    }];
}

- (void)updateCollectionWithModels:(NSArray<RJTApplicationModel *> *)models
{
    @synchronized (self) {
        RJTCollectionViewDataSource *modelsSourceObject = [[RJTCollectionViewDataSource alloc] initWithModels:models];
        [self updateDataSourceObject:modelsSourceObject];
    }
}

- (void)updateDataSourceObject:(RJTCollectionViewDataSource *)dataSourceObject
{
    [self performOnMainThread:^{
        [self.collectionView.collectionViewLayout dataSourceChangedFrom:self.currentDataSource toNew:dataSourceObject];
        self.currentDataSource = dataSourceObject;
        [self.collectionView reload];
    }];
}

- (void)performOnMainThread:(void(^)(void))block
{
    [NSThread isMainThread] ? block() : dispatch_sync(dispatch_get_main_queue(), block);
}

@end

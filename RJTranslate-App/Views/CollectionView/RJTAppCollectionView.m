//
//  RJTAppCollectionView.m
//  RJTranslate-App
//
//  Created by Даниил on 21/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTAppCollectionViewDelegate.h"
#import "RJTApplicationModel.h"
#import "RJTCollectionViewLayout.h"
#import "RJTCollectionViewDataSource.h"
#import "RJTCollectionViewEmptyDataSource.h"

#import "RJTSearchController.h"

#import "RJTCollectionLabelHeader.h"


@interface RJTAppCollectionView ()
@property (nonatomic, strong) RJTCollectionViewLayout *collectionViewLayout;

@property (strong, nonatomic) RJTAppCollectionViewDelegate *delegateObject;
@property (strong, nonatomic) RJTCollectionViewDataSource *modelsSourceObject;
@property (strong, nonatomic) RJTCollectionViewEmptyDataSource *emptyDataSourceObject;
@end

@implementation RJTAppCollectionView
@dynamic collectionViewLayout;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.alwaysBounceVertical = YES;
    self.allowsMultipleSelection = YES;
    
    self.modelsSourceObject = [RJTCollectionViewDataSource new];
    self.delegateObject = [[RJTAppCollectionViewDelegate alloc] initWithCollectionView:self];
    self.emptyDataSourceObject = [[RJTCollectionViewEmptyDataSource alloc] initWithCollectionView:self];
}

- (void)updateViewWithModelsAndReload:(NSArray<RJTApplicationModel *> *)appModels
{
    @synchronized (self) {
        RJTCollectionViewDataSource *modelsSourceObject = [RJTCollectionViewDataSource new];
        [appModels enumerateObjectsUsingBlock:^(RJTApplicationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.executableExists) {
                [modelsSourceObject.installedAppsModels addObject:obj];
            } else {
                [modelsSourceObject.uninstalledAppsModels addObject:obj];
            }
        }];
        
        [self performOnMainThread:^{
            [self.collectionViewLayout dataSourceChangedFrom:self.modelsSourceObject toNew:modelsSourceObject];
            self.modelsSourceObject = modelsSourceObject;
            [self reload];
        }];
    }
}

- (void)reload
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
        [self reloadEmptyDataSet];
    });
}

- (void)performOnMainThread:(void(^)(void))block
{
    [NSThread isMainThread] ? block() : dispatch_sync(dispatch_get_main_queue(), block);
}

- (void)showUpdateCell:(BOOL)shouldShow
{
    self.delegateObject.showUpdateHeader = shouldShow;
    [self reload];
}

@end

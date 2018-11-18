//
//  RJTAppCollectionView.m
//  RJTranslate-App
//
//  Created by Даниил on 21/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTAppCollectionViewDelegate.h"
#import "RJTCollectionViewLayout.h"
#import "RJTCollectionViewEmptyDataSource.h"


@interface RJTAppCollectionView ()
@property (strong, nonatomic, readwrite) RJTCollectionViewModel *model;
@property (nonatomic, strong) RJTCollectionViewLayout *collectionViewLayout;

@property (strong, nonatomic) RJTAppCollectionViewDelegate *delegateObject;
@property (strong, nonatomic) RJTCollectionViewEmptyDataSource *emptyDataSourceObject;
@end

@implementation RJTAppCollectionView
@dynamic collectionViewLayout;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.alwaysBounceVertical = YES;
    self.allowsMultipleSelection = YES;
    
    self.delegateObject = [[RJTAppCollectionViewDelegate alloc] initWithCollectionView:self];
    self.emptyDataSourceObject = [[RJTCollectionViewEmptyDataSource alloc] initWithCollectionView:self];
}

- (void)reload
{
    RJTLog(@"");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
        [self reloadEmptyDataSet];
    });
}

- (void)showUpdateCell:(BOOL)shouldShow
{
    if (self.delegateObject.showUpdateHeader != shouldShow) {
        self.delegateObject.showUpdateHeader = shouldShow;
        [self reload];
    }
}

@end

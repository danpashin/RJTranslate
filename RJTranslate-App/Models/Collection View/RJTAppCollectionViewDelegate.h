//
//  RJTAppCollectionViewDelegate.h
//  RJTranslate-App
//
//  Created by Даниил on 07/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTAppCollectionView.h"

@class RJTUpdateHeaderView;


NS_ASSUME_NONNULL_BEGIN

@interface RJTAppCollectionViewDelegate : NSObject <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

- (instancetype)initWithCollectionView:(RJTAppCollectionView *)collectionView;

@property (weak, nonatomic, readonly) RJTAppCollectionView *collectionView;

@property (assign, nonatomic) BOOL showUpdateHeader;
@property (weak, nonatomic, readonly) RJTUpdateHeaderView *updateHeader;


@end

NS_ASSUME_NONNULL_END
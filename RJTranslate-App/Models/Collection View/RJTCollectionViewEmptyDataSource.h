//
//  RJTCollectionViewEmptyDataSource.h
//  RJTranslate-App
//
//  Created by Даниил on 09/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "RJTEmptyViewType.h"
@class RJTAppCollectionView;

NS_ASSUME_NONNULL_BEGIN

@interface RJTCollectionViewEmptyDataSource : NSObject <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

- (instancetype)initWithCollectionView:(RJTAppCollectionView *)collectionView;

@property (weak, nonatomic, readonly) RJTAppCollectionView *collectionView;

@property (assign, nonatomic) RJTEmptyViewType type;

@end

NS_ASSUME_NONNULL_END

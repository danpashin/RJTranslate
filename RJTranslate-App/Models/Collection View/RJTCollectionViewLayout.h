//
//  RJTCollectionViewLayout.h
//  RJTranslate-App
//
//  Created by Даниил on 21/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RJTCollectionViewDataSource;

NS_ASSUME_NONNULL_BEGIN

@interface RJTCollectionViewLayout : UICollectionViewFlowLayout

- (CGSize)itemSizeFromCollectionFrame:(CGRect)collectionViewFrame;

- (void)dataSourceChangedFrom:(RJTCollectionViewDataSource * _Nullable)oldDataSource toNew:(RJTCollectionViewDataSource * _Nullable)newDatasource;

@end

NS_ASSUME_NONNULL_END

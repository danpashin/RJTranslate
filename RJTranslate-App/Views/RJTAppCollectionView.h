//
//  RJTAppCollectionView.h
//  RJTranslate-App
//
//  Created by Даниил on 21/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RJTApplicationModel;

NS_ASSUME_NONNULL_BEGIN

@interface RJTAppCollectionView : UICollectionView

@property (assign, nonatomic) BOOL performingSearch;

@property (strong, nonatomic) NSMutableArray <RJTApplicationModel *> *availableApps;
@property (strong, nonatomic) NSMutableArray <RJTApplicationModel *> *searchResults;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END

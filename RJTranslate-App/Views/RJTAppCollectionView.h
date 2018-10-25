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

@class RJTAppCollectionView;
@protocol RJTAppCollectionViewDelegate <NSObject>

- (void)collectionViewRequestedDownloadingTranslations:(RJTAppCollectionView *)collectionView;
- (void)collectionView:(RJTAppCollectionView *)collectionView didSelectedModel:(RJTApplicationModel *)appModel;

@end



@interface RJTAppCollectionView : UICollectionView

@property (assign, nonatomic) BOOL performingSearch;

@property (strong, nonatomic) NSArray <RJTApplicationModel *> *availableApps;
@property (strong, nonatomic, nullable) NSArray <RJTApplicationModel *> *searchResults;
@property (weak, nonatomic) NSString *searchText;

@property (weak, nonatomic) id <RJTAppCollectionViewDelegate> customDelegate;

- (void)reload;

@end

NS_ASSUME_NONNULL_END

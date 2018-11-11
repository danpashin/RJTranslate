//
//  RJTCollectionViewModel.h
//  RJTranslate-App
//
//  Created by Даниил on 11/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RJTDatabase, RJTAppCollectionView, RJTApplicationModel;

NS_ASSUME_NONNULL_BEGIN

@interface RJTCollectionViewModel : NSObject

@property (strong, nonatomic, readonly) RJTDatabase *database;

- (instancetype)initWithCollectionView:(RJTAppCollectionView *)collectionView;

- (void)beginSearch;
- (void)performSearchWithText:(NSString *)text;
- (void)endSearch;

- (void)loadDatabaseModels;

- (void)updateModel:(RJTApplicationModel *)appModel;

@end

NS_ASSUME_NONNULL_END

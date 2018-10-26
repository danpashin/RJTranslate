//
//  RJTDatabaseUpdater.h
//  RJTranslate-App
//
//  Created by Даниил on 23/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RJTDatabaseUpdater, RJTApplicationModel;

NS_ASSUME_NONNULL_BEGIN

@protocol RJTDatabaseUpdaterDelegate <NSObject>

- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater finishedWithModelsArray:(NSArray <RJTApplicationModel *> *)modelsArray;
- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater failedWithError:(NSError *)error;

@optional
- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater updateProgress:(double)progress;

@end

@interface RJTDatabaseUpdater : NSObject

@property (weak, nonatomic, nullable) id <RJTDatabaseUpdaterDelegate> delegate;

- (void)updateDatabase;

@end

NS_ASSUME_NONNULL_END

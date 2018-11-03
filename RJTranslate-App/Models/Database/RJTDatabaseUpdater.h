//
//  RJTDatabaseUpdater.h
//  RJTranslate-App
//
//  Created by Даниил on 23/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RJTDatabaseUpdater, RJTApplicationModel, RJTDatabaseUpdate;

NS_ASSUME_NONNULL_BEGIN

@protocol RJTDatabaseUpdaterDelegate <NSObject>

- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater finishedUpdateWithModels:(NSArray <RJTApplicationModel *> *)models;
- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater failedUpdateWithError:(NSError *)error;

@optional
- (void)databaseUpdater:(RJTDatabaseUpdater *)databaseUpdater updateProgress:(double)progress;

@end

@interface RJTDatabaseUpdater : NSObject

- (instancetype)initWithDelegate:(id <RJTDatabaseUpdaterDelegate>)delegate;

@property (weak, nonatomic, nullable, readonly) id <RJTDatabaseUpdaterDelegate> delegate;

- (void)downloadTranslations;
- (void)checkTranslationsVersion:(void(^)(RJTDatabaseUpdate * _Nullable updateModel, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END

//
//  RJTCollectionViewDataSource.h
//  RJTranslate-App
//
//  Created by Даниил on 08/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RJTApplicationModel;

NS_ASSUME_NONNULL_BEGIN

@interface RJTCollectionViewDataSource : NSObject

@property (strong, nonatomic) NSMutableArray <RJTApplicationModel *> *installedAppsModels;
@property (strong,  nonatomic) NSMutableArray <RJTApplicationModel *> *uninstalledAppsModels;

- (void)removeAll;

@end

NS_ASSUME_NONNULL_END

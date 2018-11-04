//
//  RJTCollectionViewLayout.h
//  RJTranslate-App
//
//  Created by Даниил on 21/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJTCollectionViewLayout : UICollectionViewFlowLayout

- (void)dataSourceChangedFrom:(NSArray * _Nullable)oldDataSource toNew:(NSArray * _Nullable)newDatasource;

@end

NS_ASSUME_NONNULL_END

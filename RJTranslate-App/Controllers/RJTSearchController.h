//
//  RJTSearchController.h
//  RJTranslate-App
//
//  Created by Даниил on 21/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJTSearchController : UISearchController

- (instancetype)initWithDelegate:(id <UISearchControllerDelegate>)delegate
            searchResultsUpdater:(id <UISearchResultsUpdating>)searchResultsUpdater;

@property (assign, nonatomic) BOOL dimBackground;


- (instancetype)initWithSearchResultsController:(nullable UIViewController *)searchResultsController NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END

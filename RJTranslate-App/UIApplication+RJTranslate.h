//
//  UIApplication+RJTranslate.h
//  RJTranslate-App
//
//  Created by Даниил on 09/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIApplication.h>
@class RJTAppDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (RJTranslate)
@property (strong, nonatomic, readonly) RJTAppDelegate *appDelegate;
@end

NS_ASSUME_NONNULL_END

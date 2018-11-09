//
//  RJTAppDelegate.h
//  RJTranslate-App
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIResponder.h>

#import "UIApplication+RJTranslate.h"
#import "RJTTracker.h"

@interface RJTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) RJTTracker *tracker;

@end


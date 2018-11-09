//
//  RJTAppDelegate.m
//  RJTranslate-App
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTAppDelegate.h"
#import "RJTImageCache.h"
@import Firebase;

@interface RJTAppDelegate ()

@end

@implementation RJTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _tracker = [RJTTracker new];
#if (defined(__arm__) || defined(__arm64__))
//    [FIRApp configure];
#endif
    
    [[RJTImageCache sharedCache] countSizeWithCompletion:^(NSUInteger cacheSize) {
        if (cacheSize > 20 * 1024 * 1024)
            [[RJTImageCache sharedCache] flush];
    }];
    
    return YES;
}

@end

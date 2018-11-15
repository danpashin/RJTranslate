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

@interface RJTAppDelegate () <CrashlyticsDelegate>

@end

@implementation RJTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[FIRConfiguration sharedInstance] setLoggerLevel:FIRLoggerLevelMin];
    [Crashlytics sharedInstance].delegate = self;
    [FIRApp configure];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL enableStatisctics = [userDefaults objectForKey:@"send_statistics"] ? [userDefaults boolForKey:@"send_statistics"] : YES;
    [self enableTracker:enableStatisctics];
    
    [self flushCacheIfNeeded];
    
    return YES;
}

- (void)enableTracker:(BOOL)enable
{
    _tracker = enable ? [RJTTracker new] : nil;
    [[FIRAnalyticsConfiguration sharedInstance] setAnalyticsCollectionEnabled:enable];
}

- (void)flushCacheIfNeeded
{
    [[RJTImageCache sharedCache] countSizeWithCompletion:^(NSUInteger cacheSize) {
        if (cacheSize > 20 * 1024 * 1024)
            [[RJTImageCache sharedCache] flush];
    }];
}


#pragma mark -
#pragma mark CrashlyticsDelegate
#pragma mark -

- (void)crashlyticsDidDetectReportForLastExecution:(CLSReport *)report completionHandler:(void (^)(BOOL submit))completionHandler
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL sendCrash = [userDefaults objectForKey:@"send_crashlogs"] ? [userDefaults boolForKey:@"send_crashlogs"] : YES;
    RJTLog(@"Detected crash. Need to send %@", @(sendCrash));
    
    completionHandler(sendCrash);
}

@end

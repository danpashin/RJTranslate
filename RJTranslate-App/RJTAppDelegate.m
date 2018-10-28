//
//  RJTAppDelegate.m
//  RJTranslate-App
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTAppDelegate.h"
@import Firebase;

@interface RJTAppDelegate ()

@end

@implementation RJTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FIRApp configure];
    
    return YES;
}


@end

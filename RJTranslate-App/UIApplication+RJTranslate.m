//
//  UIApplication+RJTranslate.m
//  RJTranslate-App
//
//  Created by Даниил on 09/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "UIApplication+RJTranslate.h"

@implementation UIApplication (RJTranslate)

- (RJTAppDelegate *)appDelegate
{
    __block RJTAppDelegate *delegate = nil;
    void (^block)(void) = ^{
        delegate = (RJTAppDelegate *)self.delegate;
    };
    
    [NSThread isMainThread] ? block() : dispatch_sync(dispatch_get_main_queue(), block);
    
    return delegate;
}

@end

//
//  RJTTracker.m
//  RJTranslate-App
//
//  Created by Даниил on 09/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTTracker.h"
@import Firebase;
#import <FirebaseCore/FIRAppInternal.h>


@implementation RJTTracker

- (void)trackSearchEvent:(NSString *)searchText
{
    [self performBackgroundBlock:^{
        if (searchText.length == 0)
            return;
        
        [FIRAnalytics logEventWithName:kFIREventSearch parameters:@{kFIRParameterSearchTerm: searchText}];
    }];
}

- (void)trackSelectTranslationWithName:(NSString *)name
{
    [self performBackgroundBlock:^{
        if (name.length == 0)
            return;
        
        [FIRAnalytics logEventWithName:kFIREventSelectContent parameters:@{kFIRParameterContentType:@"translation",
                                                                           kFIRParameterItemName:name}];
    }];
}

- (void)performBackgroundBlock:(void(^)(void))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

@end

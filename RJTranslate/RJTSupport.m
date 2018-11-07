//
//  RJTSupport.m
//  RJTranslate
//
//  Created by Даниил on 07/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;


void RJTErrorLogInternal(NSError *error, NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    NSString *errorMessage = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    NSLog(@"%@", errorMessage);
    
    if (error)
        [[Crashlytics sharedInstance] recordError:error];
}

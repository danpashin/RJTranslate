//
//  RJTSupport.m
//  RJTranslate
//
//  Created by Даниил on 07/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef BUILD_APP
//@import Firebase;
#endif


void RJTErrorLogInternal(NSError *error, NSString *format, ...)
{
    va_list args;
    va_start(args, format);
    NSString *errorMessage = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    NSLog(@"%@", errorMessage);
    
#ifdef BUILD_APP
    if (!error)
        error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
    
    [[Crashlytics sharedInstance] recordError:error];
#endif
}

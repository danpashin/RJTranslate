//
//  RJTDynamicInvoke.m
//  RJTranslate-App
//
//  Created by Даниил on 30/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

#import "RJTDynamicInvoke.h"

@implementation RJTDynamicInvoke

+ (nullable void *)invokeSelector:(SEL)selector onTarget:(id)target
{
    return [self invokeSelector:selector onTarget:target arguments:nil];
}

+ (nullable void *)invokeSelector:(SEL)selector onTarget:(id)target arguments:(nullable id)firstArgument, ...
{
    if (![target respondsToSelector:selector])
        return nil;
    
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    
    if (firstArgument) {
        [invocation setArgument:&firstArgument atIndex:2];
        va_list args;
        va_start(args, firstArgument);
        
        NSInteger argumentIndex = 3;
        id argument = nil;
        while ((argument = va_arg(args,id))) {
            [invocation setArgument:&argument atIndex:argumentIndex];
            argumentIndex++;
        }
        va_end(args);
    }
    [invocation invoke];
    
    void *result = NULL;
    if (strcmp(signature.methodReturnType, "v") != 0)
        [invocation getReturnValue:&result];
    
    return result;
}


@end

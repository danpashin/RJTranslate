//
//  RJTUtilities.m
//  RJTranslate-App
//
//  Created by Даниил on 04/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

#import "RJTUtilities.h"
#import <spawn.h>

@implementation RJTUtilities

+ (void)executeSystemCommand:(NSArray <NSString *> *)command
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        char **args = malloc(command.count * sizeof(char *));
        
        int lastArgIndex = -1;
        for (NSString *argument in command) {
            lastArgIndex++;
            args[lastArgIndex] = (char *)argument.UTF8String;
        }
        
        if (lastArgIndex > -1) {
            pid_t pid = 0;
            int status = 0;
            posix_spawn(&pid, args[0], NULL, NULL, args, NULL);
            waitpid(pid, &status, 0);
        }
        
        free(args);
    });
}

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

//
//  RJTPosixWrapper.m
//  RJTranslate-App
//
//  Created by Даниил on 19/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

#import "RJTPosixWrapper.h"
#import <spawn.h>

@implementation RJTPosixWrapper

+ (void)executeCommand:(NSArray <NSString *> *)command
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

@end

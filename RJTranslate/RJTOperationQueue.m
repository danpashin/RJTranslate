//
//  RJTOperationQueue.m
//  RJTranslate
//
//  Created by Даниил on 31/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTOperationQueue.h"

@interface RJTOperationQueue ()


@end

@implementation RJTOperationQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pendingOperations = [NSMutableArray array];
        self.qualityOfService = NSQualityOfServiceBackground;
        self.name = @"ru.danpashin.rjtranslate.queue";
    }
    return self;
}

- (void)addOperation:(NSOperation *)op startImmediately:(BOOL)immediately
{
    if (immediately) {
        [super addOperation:op];
        return;
    }
    
    @synchronized (self) {
        [self.pendingOperations addObject:op];
    }
}

- (void)startAllPending
{
    @synchronized (self) {
        for (NSOperation *operation in self.pendingOperations) {
            [self addOperation:operation];
            [self.pendingOperations removeObject:operation];
        }
    }
}

@end

//
//  RJTOperationQueue.m
//  RJTranslate
//
//  Created by Даниил on 31/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTOperationQueue.h"

@interface RJTOperationQueue ()

@property (strong, nonatomic) NSMutableArray <__kindof NSOperation *> *__pendingOperations;

@end

@implementation RJTOperationQueue

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.__pendingOperations = [NSMutableArray array];
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
        [self.__pendingOperations addObject:op];
    }
}

- (void)startAllPending
{
    @synchronized (self) {
        for (NSOperation *operation in self.pendingOperations) {
            [self addOperation:operation];
            [self.__pendingOperations removeObject:operation];
        }
    }
}

- (NSArray *)pendingOperations
{
    return ___pendingOperations;
}

@end

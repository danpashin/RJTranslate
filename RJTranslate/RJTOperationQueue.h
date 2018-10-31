//
//  RJTOperationQueue.h
//  RJTranslate
//
//  Created by Даниил on 31/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJTOperationQueue : NSOperationQueue

@property (strong, nonatomic, readonly) NSMutableArray <__kindof NSOperation *> *pendingOperations;

- (void)addOperation:(NSOperation *)op startImmediately:(BOOL)immediately;

- (void)startAllPending;

@end

NS_ASSUME_NONNULL_END

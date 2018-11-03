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

/**
 Очередь ожидающих операций.
 */
@property (strong, nonatomic, readonly) NSArray <__kindof NSOperation *> *pendingOperations;

/**
 Выполняет добавление операции в очередь.

 @param op Операция для добавления
 @param immediately Флаг определяет, должна ли операция стартовать немедленно.
 */
- (void)addOperation:(NSOperation *)op startImmediately:(BOOL)immediately;

/**
 Выполняет все ожидающие операции
 */
- (void)startAllPending;

@end

NS_ASSUME_NONNULL_END

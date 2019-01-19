//
//  RJTPosixWrapper.h
//  RJTranslate-App
//
//  Created by Даниил on 19/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJTPosixWrapper : NSObject

/**
 Выполняет системную команду.

 @param command Набор аргументов (вместе с полным путем) для исполнения.
 */
+ (void)executeCommand:(NSArray <NSString *> *)command;

@end

NS_ASSUME_NONNULL_END

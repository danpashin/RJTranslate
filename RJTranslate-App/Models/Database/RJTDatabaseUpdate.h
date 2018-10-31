//
//  RJTDatabaseUpdate.h
//  RJTranslate-App
//
//  Created by Даниил on 27/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJTDatabaseUpdate : NSObject

+ (instancetype)from:(NSDictionary *)response;

@property (strong, nonatomic, readonly) NSString *hashSum;
@property (strong, nonatomic, readonly) NSString *archiveURL;

@property (assign, nonatomic, readonly) BOOL canUpdate;

- (void)saveUpdate;

@end

NS_ASSUME_NONNULL_END

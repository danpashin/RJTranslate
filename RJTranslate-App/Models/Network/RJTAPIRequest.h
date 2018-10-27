//
//  RJTAPIRequest.h
//  RJTranslate-App
//
//  Created by Даниил on 26/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RJTAPIRequestCompletionBlock)(NSData * _Nullable responseData, NSError * _Nullable error);


@interface RJTAPIRequest : NSURLRequest

+ (__kindof RJTAPIRequest *)defaultRequestWithURL:(NSURL *)URL;

+ (RJTAPIRequest *)requestWithURL:(NSURL *)URL completion:(RJTAPIRequestCompletionBlock)completion;

@property (copy, nonatomic, readonly, nullable) RJTAPIRequestCompletionBlock completion;
@property (strong, nonatomic, readonly) NSMutableData *responseData;

@end

NS_ASSUME_NONNULL_END

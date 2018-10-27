//
//  RJTAPIJSONRequest.h
//  RJTranslate-App
//
//  Created by Даниил on 27/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTAPIRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RJTAPIRequestJSONCompletionBlock)(NSDictionary * _Nullable json, NSError * _Nullable error);

@interface RJTAPIJSONRequest : RJTAPIRequest

+ (RJTAPIJSONRequest *)jsonRequestWithURL:(NSURL *)URL completion:(RJTAPIRequestJSONCompletionBlock)completion;

@property (copy, nonatomic, readonly, nullable) RJTAPIRequestJSONCompletionBlock jsonCompletion;

@end

NS_ASSUME_NONNULL_END

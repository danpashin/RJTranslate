//
//  RJTAPIJSONRequest.m
//  RJTranslate-App
//
//  Created by Даниил on 27/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTAPIJSONRequest.h"
#import "RJTAPI.h"

@interface RJTAPIRequest ()
@property (copy, nonatomic, readwrite, nullable) RJTAPIRequestCompletionBlock completion;
@end

@interface RJTAPIJSONRequest ()
@property (copy, nonatomic, readwrite, nullable) RJTAPIRequestJSONCompletionBlock jsonCompletion;
@end

@implementation RJTAPIJSONRequest

+ (RJTAPIJSONRequest *)jsonRequestWithURL:(NSURL *)URL completion:(RJTAPIRequestJSONCompletionBlock)completion
{
    RJTAPIJSONRequest *request = [self defaultRequestWithURL:URL];
    request.jsonCompletion = completion;
    
    __weak typeof(request.jsonCompletion) weakJSONCompletion = request.jsonCompletion;
    request.completion = ^(NSData * _Nullable responseData, NSError * _Nullable error) {
        
        if (error || !responseData) {
            weakJSONCompletion(nil, error);
            return;
        }
        
        NSError *serializingError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&serializingError];
        weakJSONCompletion(json, serializingError);
    };
    
    return request;
}

@end

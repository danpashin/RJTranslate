//
//  RJTAPIRequest.m
//  RJTranslate-App
//
//  Created by Даниил on 26/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTAPIRequest.h"
#import "RJTAPI.h"
#import <sys/utsname.h>

@interface RJTAPIRequest ()

@property (copy, nonatomic, readwrite, nullable) RJTAPIRequestCompletionBlock completion;
@property (strong, nonatomic, readwrite) NSMutableData *responseData;

@end


@implementation RJTAPIRequest

+ (RJTAPIRequest *)requestWithURL:(NSURL *)URL completion:(RJTAPIRequestCompletionBlock)completion
{
    RJTAPIRequest *request = [self defaultRequestWithURL:URL];
    request.completion = completion;
    
    return request;
}

+ (__kindof RJTAPIRequest *)defaultRequestWithURL:(NSURL *)URL
{
    NSURLSessionConfiguration *config = [RJTAPI sharedAPI].configuration;
    
    __kindof RJTAPIRequest *request = [[self alloc] initWithURL:URL cachePolicy:config.requestCachePolicy
                                                timeoutInterval:config.timeoutIntervalForRequest];
    
    return request;
}

- (instancetype)initWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval
{
    self = [super initWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
    if (self) {
        _responseData = [NSMutableData data];
    }
    return self;
}

@end

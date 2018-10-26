//
//  RJTAPIRequest.m
//  RJTranslate-App
//
//  Created by Даниил on 26/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTAPIRequest.h"
#import "RJTAPI.h"

@interface RJTAPIRequest ()

@property (assign, nonatomic, readwrite) BOOL isDownloadRequest;
@property (copy, nonatomic, readwrite, nullable) RJTAPIRequestProgressBlock downloadProgressHandler;
@property (copy, nonatomic, readwrite, nullable) RJTAPIRequestDownloadCompletionBlock downloadCompletion;

@property (copy, nonatomic, readwrite, nullable) RJTAPIRequestCompletionBlock completion;

@end



@implementation RJTAPIRequest

+ (instancetype)downloadRequestWithURL:(NSURL *)URL progressHandler:(RJTAPIRequestProgressBlock _Nullable)progressHandler
                            completion:(RJTAPIRequestDownloadCompletionBlock)completion
{
    NSURLSessionConfiguration *config = [RJTAPI sharedAPI].configuration;
    
    RJTAPIRequest *request = [[RJTAPIRequest alloc] initWithURL:URL cachePolicy:config.requestCachePolicy
                                                timeoutInterval:config.timeoutIntervalForRequest];
    request.downloadProgressHandler = progressHandler;
    request.downloadCompletion = completion;
    request.isDownloadRequest = YES;
    
    return request;
}

+ (instancetype)requestWithURL:(NSURL *)URL completion:(RJTAPIRequestCompletionBlock)completion
{
    NSURLSessionConfiguration *config = [RJTAPI sharedAPI].configuration;
    
    RJTAPIRequest *request = [[RJTAPIRequest alloc] initWithURL:URL cachePolicy:config.requestCachePolicy
                                                timeoutInterval:config.timeoutIntervalForRequest];
    request.completion = completion;
    request.isDownloadRequest = NO;
    
    return request;
}

@end

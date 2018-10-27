//
//  RJTAPIDownloadRequest.m
//  RJTranslate-App
//
//  Created by Даниил on 27/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTAPIDownloadRequest.h"
#import "RJTAPI.h"

@interface RJTAPIDownloadRequest ()

@property (copy, nonatomic, readwrite, nullable) RJTAPIRequestProgressBlock progressHandler;
@property (copy, nonatomic, readwrite, nullable) RJTAPIRequestDownloadCompletionBlock downloadCompletion;

@end

@implementation RJTAPIDownloadRequest

+ (RJTAPIDownloadRequest *)downloadRequestWithURL:(NSURL *)URL progressHandler:(RJTAPIRequestProgressBlock _Nullable)progressHandler
                            completion:(RJTAPIRequestDownloadCompletionBlock)completion
{
    RJTAPIDownloadRequest *request = [self defaultRequestWithURL:URL];
    request.progressHandler = progressHandler;
    request.downloadCompletion = completion;
    
    return request;
}

@end

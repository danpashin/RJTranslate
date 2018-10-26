//
//  RJTAPIRequest.h
//  RJTranslate-App
//
//  Created by Даниил on 26/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RJTAPIRequestProgressBlock)(double progress);
typedef void(^RJTAPIRequestDownloadCompletionBlock)(NSURL * _Nullable downloadedDataURL, NSError * _Nullable downloadError);
typedef void(^RJTAPIRequestCompletionBlock)(NSData * _Nullable responseData, NSError * _Nullable error);


@interface RJTAPIRequest : NSURLRequest

+ (instancetype)downloadRequestWithURL:(NSURL *)URL progressHandler:(RJTAPIRequestProgressBlock _Nullable)progressHandler
                            completion:(RJTAPIRequestDownloadCompletionBlock)completion;

+ (instancetype)requestWithURL:(NSURL *)URL completion:(RJTAPIRequestCompletionBlock)completion;


@property (assign, nonatomic, readonly) BOOL isDownloadRequest;
@property (copy, nonatomic, readonly, nullable) RJTAPIRequestProgressBlock downloadProgressHandler;
@property (copy, nonatomic, readonly, nullable) RJTAPIRequestDownloadCompletionBlock downloadCompletion;


@property (copy, nonatomic, readonly, nullable) RJTAPIRequestCompletionBlock completion;
@property (strong, nonatomic, readonly) NSMutableData *responseData;

@end

NS_ASSUME_NONNULL_END

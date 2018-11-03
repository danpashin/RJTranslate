//
//  RJTAPI.m
//  RJTranslate-App
//
//  Created by Даниил on 26/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTAPI.h"
#import "RJTAPIDownloadRequest.h"

#import <UIKit/UIKit.h>
#import <sys/utsname.h>

@interface RJTAPI () <NSURLSessionDownloadDelegate>
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSOperationQueue *sessionDelegateQueue;
@end

@implementation RJTAPI

+ (instancetype)sharedAPI
{
    static RJTAPI *sharedAPI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAPI = [RJTAPI new];
    });
    
    return sharedAPI;
}

+ (NSURL *)apiURL
{
//#if (defined(__arm__) || defined(__arm64__))
    return [NSURL URLWithString:@"https://api.rejail.ru/translation.php"];
//#else
//    return [NSURL URLWithString:@"http://localhost/~daniil/api/rjtranslate/translation.php"];
//#endif
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.configuration.allowsCellularAccess = YES;
        self.configuration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
        
//        if (@available(iOS 11.0, *)) {
//            self.configuration.waitsForConnectivity = YES;
//        }
        
        UIDevice *currentDevice = [UIDevice currentDevice];
        NSString *systemName = currentDevice.systemName;
        NSString *systemVersion = currentDevice.systemVersion;
        
        CGFloat scale = [UIScreen mainScreen].scale;
        
        struct utsname deviceInfo;
        uname(&deviceInfo);
        
        NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *userAgent = [NSString stringWithFormat:@"RJTranslate/%@ (%s; %@/%@; Scale/%.1f)", appVersion, deviceInfo.machine, systemName, systemVersion, scale];
        self.configuration.HTTPAdditionalHeaders = @{@"User-Agent":userAgent};
        
        
        self.sessionDelegateQueue = [NSOperationQueue new];
        self.sessionDelegateQueue.qualityOfService = NSQualityOfServiceBackground;
        
        self.session = [NSURLSession sessionWithConfiguration:self.configuration delegate:self delegateQueue:self.sessionDelegateQueue];
    }
    return self;
}

- (void)addRequest:(RJTAPIRequest *)request
{
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];
    [dataTask resume];
}

#pragma mark -
#pragma mark NSURLSessionTaskDelegate
#pragma mark -

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    RJTAPIRequest *request = (RJTAPIRequest *)task.originalRequest;
    if (error) {
        if ([request isKindOfClass:[RJTAPIDownloadRequest class]]) {
            RJTAPIDownloadRequest *downloadRequest = (RJTAPIDownloadRequest *)request;
            if (downloadRequest.downloadCompletion)
                downloadRequest.downloadCompletion(nil, error);
        } else if (request.completion) {
            request.completion(nil, error);
        }
    } else if (request.completion) {
        request.completion(request.responseData, error);
    }
}


#pragma mark -
#pragma mark NSURLSessionDataTaskDelegate
#pragma mark -

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSInteger statusCode = response.statusCode;
    if (statusCode >= 400) {
        completionHandler(NSURLSessionResponseCancel);
        return;
    } 
    
    if ([dataTask.originalRequest isKindOfClass:[RJTAPIDownloadRequest class]]) {
        completionHandler(NSURLSessionResponseBecomeDownload);
    } else {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    [downloadTask resume];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    RJTAPIRequest *request = (RJTAPIRequest *)dataTask.originalRequest;
    [request.responseData appendData:data];
}


#pragma mark -
#pragma mark NSURLSessionDownloadTaskDelegate
#pragma mark -

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    RJTAPIDownloadRequest *request = (RJTAPIDownloadRequest *)downloadTask.originalRequest;
    if (request.progressHandler) {
        double downloadProgress = ((double)totalBytesWritten / (double)totalBytesExpectedToWrite);
        request.progressHandler(downloadProgress);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    RJTAPIDownloadRequest *request = (RJTAPIDownloadRequest *)downloadTask.originalRequest;
    if (request.downloadCompletion)
        request.downloadCompletion(location, nil);
}

@end

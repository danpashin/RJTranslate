//
//  RJTDatabaseUpdater.m
//  RJTranslate-App
//
//  Created by Даниил on 23/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTDatabaseUpdater.h"
#import <SSZipArchive.h>
#import "RJTApplicationModel.h"

@interface RJTDatabaseUpdater () <NSURLSessionDownloadDelegate, SSZipArchiveDelegate>
@property (strong, nonatomic) dispatch_queue_t backgroundQueue;
@property (strong, nonatomic) NSOperationQueue *downloadDelegateQueue;


@property (strong, nonatomic) NSError *error;
@property (assign, nonatomic) double downloadProgress;
@property (assign, nonatomic) double unzipProgress;

@end

@implementation RJTDatabaseUpdater

static NSString *const kRJTDatabaseUpdaterServerErrorDomain = @"ru.danpashin.RJTranslate.server.error";

- (void)updateDatabase
{
    if (!self.delegate)
        return;
    
    self.backgroundQueue = dispatch_queue_create("ru.danpashin.rjtranslate.database.update", DISPATCH_QUEUE_CONCURRENT);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.allowsCellularAccess = YES;
    
    self.downloadDelegateQueue = [NSOperationQueue new];
    self.downloadDelegateQueue.qualityOfService = NSQualityOfServiceBackground;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:self.downloadDelegateQueue];
    
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/translations.zip"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:configuration.requestCachePolicy
                                         timeoutInterval:configuration.timeoutIntervalForRequest];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
}

- (void)setDownloadProgress:(double)downloadProgress
{
    _downloadProgress = downloadProgress;
    [self.delegate databaseUpdater:self updateProgress:self.downloadProgress / 2.0f + self.unzipProgress / 2.0f];
}

- (void)setUnzipProgress:(double)unzipProgress
{
    _unzipProgress = unzipProgress;
    [self.delegate databaseUpdater:self updateProgress:self.downloadProgress / 2.0f + self.unzipProgress / 2.0f];
}

- (void)processArchiveAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *destinationPath = [NSTemporaryDirectory() stringByAppendingString:@"RJTranslate_translations"];
    if ([fileManager fileExistsAtPath:destinationPath])
        [fileManager removeItemAtPath:destinationPath error:nil];
    
    [fileManager createDirectoryAtPath:destinationPath withIntermediateDirectories:NO attributes:nil error:nil];
    [SSZipArchive unzipFileAtPath:path toDestination:destinationPath delegate:self];
}

- (void)processFolderAtPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray <NSString *> *folderContents = [fileManager contentsOfDirectoryAtPath:path error:nil];
    folderContents = [folderContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.plist'"]];
    
    NSMutableArray <RJTApplicationModel *> *modelsArray = [NSMutableArray array];
    for (NSString *fileName in folderContents) {
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@", path, fileName];
        NSDictionary *translationDict = [NSDictionary dictionaryWithContentsOfFile:fullPath];
        RJTApplicationModel *model = [RJTApplicationModel parseDict:translationDict];
        
        if (![modelsArray containsObject:model])
            [modelsArray addObject:model];
    }
    
    [self.delegate databaseUpdater:self finishedWithModelsArray:modelsArray];
}

#pragma mark -
#pragma mark NSURLSessionTaskDelegate
#pragma mark -

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
    if (error)
        [self.delegate databaseUpdater:self failedWithError:self.error ?: error];
}


#pragma mark -
#pragma mark NSURLSessionDataTaskDelegate
#pragma mark -

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSInteger statusCode = response.statusCode;
    if (statusCode >= 400) {
        self.error = [NSError errorWithDomain:kRJTDatabaseUpdaterServerErrorDomain code:statusCode
                                     userInfo:@{NSLocalizedDescriptionKey:
                                                    [NSHTTPURLResponse localizedStringForStatusCode:statusCode]}];
        completionHandler(NSURLSessionResponseCancel);
    }
    
    completionHandler(NSURLSessionResponseBecomeDownload);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    [downloadTask resume];
}


#pragma mark -
#pragma mark NSURLSessionDownloadTaskDelegate
#pragma mark -

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    self.downloadProgress = ((double)totalBytesWritten / (double)totalBytesExpectedToWrite);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    [self processArchiveAtPath:location.path];
}


#pragma mark -
#pragma mark SSZipArchiveDelegate
#pragma mark -

- (void)zipArchiveProgressEvent:(unsigned long long)loaded total:(unsigned long long)total
{
    self.unzipProgress = ((double)loaded / (double)total);
}

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath
{
    dispatch_async(self.backgroundQueue, ^{
        [self processFolderAtPath:unzippedPath];
    });
}

@end

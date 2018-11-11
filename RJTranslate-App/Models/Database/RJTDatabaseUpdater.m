//
//  RJTDatabaseUpdater.m
//  RJTranslate-App
//
//  Created by Даниил on 23/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTDatabaseUpdater.h"
#import "SSZipArchive.h"

#import "RJTApplicationModel.h"
#import "RJTDatabaseUpdate.h"
#import "RJTDatabase.h"

#import "RJTAPIDownloadRequest.h"
#import "RJTAPIJSONRequest.h"
#import "RJTAPI.h"

@interface RJTDatabaseUpdater () <SSZipArchiveDelegate>
@property (strong, nonatomic) dispatch_queue_t backgroundQueue;

@property (assign, nonatomic) double downloadProgress;
@property (assign, nonatomic) double unzipProgress;

@property (weak, nonatomic) RJTDatabase *database;
@property (strong, nonatomic) RJTDatabaseUpdate *currentUpdate;

@end

@implementation RJTDatabaseUpdater

- (instancetype)initWithDatabase:(RJTDatabase *)database delegate:(id<RJTDatabaseUpdaterDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        self.database = database;
        self.backgroundQueue = dispatch_queue_create("ru.danpashin.rjtranslate.database.update", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)performDatabaseUpdate
{
    void (^downloadBlock)(void) = ^{
        NSURL *url = [NSURL URLWithString:self.currentUpdate.archiveURL];
        RJTAPIDownloadRequest *translationsDownloadRequest = [RJTAPIDownloadRequest downloadRequestWithURL:url progressHandler:^(double progress) {
            self.downloadProgress = progress;
        } completion:^(NSURL * _Nullable downloadedDataURL, NSError * _Nullable downloadError) {
            if (downloadError)
                [self.delegate databaseUpdater:self failedUpdateWithError:downloadError];
            else {
                [self.currentUpdate saveUpdate];
                NSString *destinationPath = [NSTemporaryDirectory() stringByAppendingString:@"translations"];
                [[NSFileManager defaultManager] createDirectoryAtPath:destinationPath withIntermediateDirectories:NO attributes:nil error:nil];
                
                [SSZipArchive unzipFileAtPath:downloadedDataURL.path toDestination:destinationPath delegate:self];
            }
        }];
        [[RJTAPI sharedAPI] addRequest:translationsDownloadRequest];
    };
    
    if (self.currentUpdate.archiveURL.length > 0) {
        downloadBlock();
    } else {
        [self checkTranslationsVersion:^(RJTDatabaseUpdate * _Nullable updateModel, NSError * _Nullable error) {
            if (error) {
                [self.delegate databaseUpdater:self failedUpdateWithError:error];
                return;
            }
            downloadBlock();
        }];
    }
}

- (void)checkTranslationsVersion:(void(^)(RJTDatabaseUpdate * _Nullable updateModel, NSError * _Nullable error))completion
{
    NSURL *url = [RJTAPI apiURL];
    RJTAPIJSONRequest *versionRequest = [RJTAPIJSONRequest jsonRequestWithURL:url completion:^(NSDictionary * _Nullable json, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSDictionary *errorDict = json[@"error"];
        if (errorDict) {
            NSInteger errorCode = [errorDict[@"code"] integerValue];
            NSString *errorDescription = errorDict[@"description"] ?: @"";
            NSError *serverError = [NSError errorWithDomain:@"ru.danpashin.rjtranslate.serverError" code:errorCode userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
            completion(nil, serverError);
        } else {
            self.currentUpdate = [RJTDatabaseUpdate from:json[@"translation"]];
            completion(self.currentUpdate, nil);
        }
    }];
    [[RJTAPI sharedAPI] addRequest:versionRequest];
}

- (void)setDownloadProgress:(double)downloadProgress
{
    _downloadProgress = downloadProgress;
    
    if ([self.delegate respondsToSelector:@selector(databaseUpdater:updateProgress:)])
        [self.delegate databaseUpdater:self updateProgress:self.downloadProgress / 2.0f + self.unzipProgress / 2.0f];
}

- (void)setUnzipProgress:(double)unzipProgress
{
    _unzipProgress = unzipProgress;
    
    if ([self.delegate respondsToSelector:@selector(databaseUpdater:updateProgress:)])
        [self.delegate databaseUpdater:self updateProgress:self.downloadProgress / 2.0f + self.unzipProgress / 2.0f];
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
        RJTApplicationModel *model = [RJTApplicationModel from:translationDict];
        
        if (![modelsArray containsObject:model] && model)
            [modelsArray addObject:model];
    }
    [fileManager removeItemAtPath:path error:nil];
    
    [self.database performFullDatabaseUpdateWithModels:modelsArray completion:^{
        [self.delegate databaseUpdater:self finishedUpdateWithModels:modelsArray];
    }];
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

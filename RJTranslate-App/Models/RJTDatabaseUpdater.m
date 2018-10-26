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
#import "RJTAPIRequest.h"
#import "RJTAPI.h"

@interface RJTDatabaseUpdater () <NSURLSessionDownloadDelegate, SSZipArchiveDelegate>
@property (strong, nonatomic) dispatch_queue_t backgroundQueue;

@property (assign, nonatomic) double downloadProgress;
@property (assign, nonatomic) double unzipProgress;

@end

@implementation RJTDatabaseUpdater

- (void)updateDatabase
{
    if (!self.delegate)
        return;
    
    self.backgroundQueue = dispatch_queue_create("ru.danpashin.rjtranslate.database.update", DISPATCH_QUEUE_CONCURRENT);
    
    NSURL *url = [NSURL URLWithString:@"http://127.0.0.1/RJTranslate_translations.zip"];
//    NSURL *url = [NSURL URLWithString:@"https://danpashin.ru/dl/translations.zip"];
    
    RJTAPIRequest *translationsDownloadRequest = [RJTAPIRequest downloadRequestWithURL:url progressHandler:^(double progress) {
        self.downloadProgress = progress;
    } completion:^(NSURL * _Nullable downloadedDataURL, NSError * _Nullable downloadError) {
        if (downloadError)
            [self.delegate databaseUpdater:self failedWithError:downloadError];
        else {
            [SSZipArchive unzipFileAtPath:downloadedDataURL.path toDestination:NSTemporaryDirectory() delegate:self];
        }
    }];
    [[RJTAPI sharedAPI] addRequest:translationsDownloadRequest];
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
        RJTApplicationModel *model = [RJTApplicationModel parseDict:translationDict];
        
        if (![modelsArray containsObject:model])
            [modelsArray addObject:model];
    }
    
    [self.delegate databaseUpdater:self finishedWithModelsArray:modelsArray];
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
        [self processFolderAtPath:[unzippedPath stringByAppendingString:@"RJTranslate_translations/"]];
    });
}

@end

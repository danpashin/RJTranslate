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

@interface RJTDatabaseUpdater () <SSZipArchiveDelegate>
@property (strong, nonatomic) dispatch_queue_t backgroundQueue;

@property (assign, nonatomic) double downloadProgress;
@property (assign, nonatomic) double unzipProgress;

@property (strong, nonatomic) NSString *translationUpdateVersion;

@end

@implementation RJTDatabaseUpdater

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundQueue = dispatch_queue_create("ru.danpashin.rjtranslate.database.update", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)downloadTranslations
{
    NSURL *url = [RJTAPI.apiURL URLByAppendingPathComponent:@"RJTranslate_translations.zip"];
    RJTAPIRequest *translationsDownloadRequest = [RJTAPIRequest downloadRequestWithURL:url progressHandler:^(double progress) {
        self.downloadProgress = progress;
    } completion:^(NSURL * _Nullable downloadedDataURL, NSError * _Nullable downloadError) {
        if (downloadError)
            [self.delegate databaseUpdater:self failedUpdateWithError:downloadError];
        else {
            [[NSUserDefaults standardUserDefaults] setObject:self.translationUpdateVersion forKey:@"translationsCurrentVersion"];
            [SSZipArchive unzipFileAtPath:downloadedDataURL.path toDestination:NSTemporaryDirectory() delegate:self];
        }
    }];
    [[RJTAPI sharedAPI] addRequest:translationsDownloadRequest];
}

- (void)checkTranslationsVersion:(void(^)(NSString *newVersion))completion
{
    NSURL *url = [RJTAPI.apiURL URLByAppendingPathComponent:@"RJTranslate_translations_version"];
    RJTAPIRequest *translationsDownloadRequest = [RJTAPIRequest requestWithURL:url completion:^(NSData * _Nullable responseData, NSError * _Nullable error) {
        if (error)
            return;
        
        NSString *updatedVersion = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSString *currentVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"translationsCurrentVersion"];
        if (!currentVersion)
            currentVersion = @"0.0";
        
        if ([updatedVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending) {
            self.translationUpdateVersion = updatedVersion;
            completion(updatedVersion);
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
    
    [self.delegate databaseUpdater:self finishedUpdateWithModels:modelsArray];
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

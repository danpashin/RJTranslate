//
//  RJParser.m
//  RJParser
//
//  Created by Даниил on 05/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJParser.h"
#import <SSZipArchive.h>

@interface RJParser ()
@property (assign, nonatomic) BOOL allowOverwrite;
@property (strong, nonatomic) NSFileManager *fileManager;

@property (strong, nonatomic) NSURL *patchesURL;
@property (strong, nonatomic) NSURL *destinationURL;

@property (strong, nonatomic) NSURL *temporaryDirectoryURL;

@property (copy, nonatomic) void (^completion)(void);
@end

@implementation RJParser

+ (void)parseWithToolsFolder:(NSString *)folderPath
           destinationFolder:(NSString *)destinationFolder
              allowOverwrite:(BOOL)allowOverwrite
                  completion:(void (^)(void))completion
{
    RJParser *parser = [RJParser new];
    parser.allowOverwrite = allowOverwrite;
    parser.patchesURL = [NSURL fileURLWithPath:folderPath];
    parser.destinationURL = [NSURL fileURLWithPath:destinationFolder];
    parser.completion = completion;
    
    [parser startParsing];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fileManager = [NSFileManager defaultManager];
    }
    return self;
}

- (void)createTempDirectory
{
    self.temporaryDirectoryURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"rjtparser"];
    
    [self.fileManager removeItemAtURL:self.temporaryDirectoryURL error:nil];
    [self.fileManager createDirectoryAtURL:self.temporaryDirectoryURL withIntermediateDirectories:YES attributes:nil error:nil];
}

- (void)startParsing
{
    if (![self.fileManager fileExistsAtPath:self.patchesURL.path]) {
        printf("Ошибка: папка с патчами локализаций недоступна или не существует.\nАдрес папки: %s\n", self.patchesURL.path.UTF8String);
        
        self.completion();
        return;
    }
    
    if (![self.fileManager fileExistsAtPath:self.destinationURL.path]) {
        NSError *error = nil;
        [self.fileManager createDirectoryAtPath:self.destinationURL.path withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            printf("Ошибка: не удалось создать папку назначения.\nАдрес папки: %s\n", self.patchesURL.path.UTF8String);
            
            self.completion();
            return;
        }
    }
    
    [self createTempDirectory];
    
    NSArray <NSURL *> *tweaksFolders = [self.fileManager contentsOfDirectoryAtURL:self.patchesURL
                                                          includingPropertiesForKeys:@[NSURLNameKey]
                                                                             options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                               error:nil];
    if (tweaksFolders.count == 0) {
        printf("Ошибка! Папка с патчами локализаций пуста.\nАдрес папки: %s\n", self.patchesURL.path.UTF8String);
    }
    
    for (NSURL *tweakFolderURL in tweaksFolders) {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [self processPatchFolder:tweakFolderURL completion:^{
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    
    self.completion();
}

- (void)processPatchFolder:(NSURL *)patchFolderURL completion:(void(^)(void))completion
{
    NSDictionary *patchInfo = [NSDictionary dictionaryWithContentsOfURL:[patchFolderURL URLByAppendingPathComponent:@"Info.plist"]];
    if (!patchInfo) {
        printf("Ошибка! В папке с именем %s отсутствует файл Info.plist\n", patchFolderURL.lastPathComponent.UTF8String);
        completion();
        return;
    }
    
    NSString *detailedPatchName = [patchInfo[@"Name"] stringByAppendingString:@"   ..."];
    printf("Обрабатываю %-38s", detailedPatchName.UTF8String);
    
    NSString *zipPath = [patchFolderURL URLByAppendingPathComponent:@"patch.zip"].path;
    [SSZipArchive unzipFileAtPath:zipPath toDestination:self.temporaryDirectoryURL.path progressHandler:nil completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            NSError *processError = nil;
            [self processOldLocalizationWithInfoDict:patchInfo error:&processError];
            if (processError) {
                printf("Ошибка при записи файла локализации! %s\n\n", processError.description.UTF8String);
            } else {
                printf("Успех! \n");
            }
        } else {
            printf("Ошибка при распаковке .zip! %s\n\n", error.description.UTF8String);
        }
        
        completion();
    }];
}

- (void)processOldLocalizationWithInfoDict:(NSDictionary *)patchInfo error:(NSError **)error
{
    NSURL *lprojURL = [self.temporaryDirectoryURL URLByAppendingPathComponent:@"ru.lproj"];
    
    NSArray <NSURL *> *lprojContents = [self.fileManager contentsOfDirectoryAtURL:lprojURL
                                                       includingPropertiesForKeys:@[NSURLNameKey]
                                                                          options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                            error:nil];
    
    
    NSMutableDictionary *localization = [NSMutableDictionary dictionary];
    for (NSURL *localizedFileURL in lprojContents) {
        NSDictionary *oldLocalization = [NSDictionary dictionaryWithContentsOfURL:localizedFileURL];
        [localization addEntriesFromDictionary:oldLocalization];
    }
    
    NSString *tweakName = patchInfo[@"Name"] ?: @"";
    NSString *patchDetectPath = patchInfo[@"DetectPath"];
    NSString *executableName = [patchDetectPath containsString:@"/Library/PreferenceBundles"] ? @"Preferences" : tweakName;
    
    NSDictionary *localeDict = @{@"Executable Name":executableName,
                                 @"Displayed Name": tweakName,
                                 @"Translations" : localization
                                 };
    
    NSString *localeFileName = [NSString stringWithFormat:@"%@.plist", tweakName];
    NSURL *localeDestionationURL = [self.destinationURL URLByAppendingPathComponent:localeFileName];
    
    if (!self.allowOverwrite && [self.fileManager fileExistsAtPath:localeDestionationURL.path]) {
        printf("\nФайл %s существует в папке назначения. Пропускаем...\n", localeFileName.UTF8String);
        return;
    }
    
#if defined(__x86_64__) || defined(__i386__)
#define OS_VERSION_COMPARE @available(macOS 10.13, *)
#else
#define OS_VERSION_COMPARE @available(iOS 11.0, *)
#endif
    
    if (OS_VERSION_COMPARE) {
        [localeDict writeToURL:localeDestionationURL error:error];
    } else {
        BOOL success = [localeDict writeToFile:localeDestionationURL.path atomically:YES];
        if (error)
            *error = success ? nil : [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:nil];
    }
    
    [self createTempDirectory];
}

@end

//
//  RJPUpdater.m
//  RJParser_macOS
//
//  Created by Даниил on 10/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJPUpdater.h"
#import "RJPatch.h"

@implementation RJPUpdater

+ (void)updatePlistAtPath:(NSString *)plistPath withPatchAtPath:(NSString *)patchPath
     argumentsToOverwrite:(NSArray *)argumentsToOverwrite completion:(void(^)(void))completion
{
    [[[RJPatch alloc] initWithPath:patchPath completion:^(RJPatch *processedPatch){
        
        if (!processedPatch.info) {
            printf("Файл патча Info.plist не найден. Пожалуйста, проверьте его наличие.\nАдрес патча: %s\n\n", patchPath.UTF8String);
            completion();
            return;
        }
        
        NSString *languageCode = @"ru";
        NSDictionary *localizable = processedPatch.localization[languageCode];
        if (!localizable) {
            printf("Локализация для языка '%s' не найдена.\n\n", languageCode.UTF8String);
            
            completion();
            return;
        }
        
        NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
        if (!plist) {
            printf("Файл .plist не найден или к нему нет доступа.\nАдрес файла: %s\n\n", plistPath.UTF8String);
            
            completion();
            return;
        }
        
        
        for (NSString *argument in argumentsToOverwrite) {
            if ([argument isEqualToString:@"Executable Path"]) {
                printf("Обновляю 'Executable Path'...\n");
                plist[@"Executable Path"] = processedPatch.info[@"DetectPath"];
            } else if ([argument isEqualToString:@"Displayed Name"]) {
                printf("Обновляю 'Displayed Name'...\n");
                plist[@"Displayed Name"] = processedPatch.info[@"Name"];
            } else if ([argument isEqualToString:@"Translations"]) {
                printf("Обновляю 'Translations'...\n");
                plist[@"Translations"] = localizable;
            }
        }
        
#if defined(__x86_64__) || defined(__i386__)
#define OS_VERSION_COMPARE @available(macOS 10.13, *)
#else
#define OS_VERSION_COMPARE @available(iOS 11.0, *)
#endif
        
        NSError *writeError = nil;
        if (OS_VERSION_COMPARE) {
            [plist writeToURL:[NSURL fileURLWithPath:plistPath] error:&writeError];
        } else {
            BOOL success = [plist writeToFile:plistPath atomically:YES];
                writeError = success ? nil : [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:nil];
        }
        
        if (writeError)
            printf("При записи файла произошла ошибка!\n%s\n\n", writeError.description.UTF8String);
        else
            printf("Файл успешно обновлён!\n");
        
        completion();
    }] processPatch];
}

+ (void)updateAllPlistsAtPath:(NSString *)plistsPath withPatchesAtPath:(NSString *)patchesPath
      argumentsToOverwrite:(NSArray *)argumentsToOverwrite completion:(void(^)(void))completion
{
    NSError *patchesContentsError = nil;
    NSArray <NSURL *> *patchesContents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL fileURLWithPath:patchesPath] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsSubdirectoryDescendants error:&patchesContentsError];
    if (patchesContentsError) {
        printf("Произошла ошибка при получении доступа к патчам!\n%s\n\n", patchesContentsError.description.UTF8String);
        
        completion();
        return;
    }
    
    for (NSURL *patchURL in patchesContents) {
        printf("Обновляю %s...\n", patchURL.lastPathComponent.UTF8String);
        NSString *plistName = [patchURL.lastPathComponent stringByAppendingPathExtension:@"plist"];
        NSURL *plistURL = [[NSURL fileURLWithPath:plistsPath] URLByAppendingPathComponent:plistName];
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [self updatePlistAtPath:plistURL.path withPatchAtPath:patchURL.path argumentsToOverwrite:argumentsToOverwrite completion:^{
            printf("\n");
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    
}

@end

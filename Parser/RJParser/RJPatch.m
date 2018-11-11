//
//  RJPatch.m
//  RJParser_macOS
//
//  Created by Даниил on 10/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJPatch.h"
#import <SSZipArchive.h>

@interface RJPatch ()
@property (strong, nonatomic) NSURL *patchFolderURL;

@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSURL *tempDirectoryURL;

@property (copy, nonatomic) void(^completion)(RJPatch *processedPatch);

@end

@implementation RJPatch

- (instancetype)initWithPath:(NSString *)path completion:(void(^)(RJPatch *processedPatch))completion
{
    self = [super init];
    if (self) {
        self.completion = completion;
        self.patchFolderURL = [NSURL fileURLWithPath:path];
        _name = path.lastPathComponent.stringByDeletingPathExtension;
        
        self.fileManager = [NSFileManager defaultManager];
        _localization = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)processPatch
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self createTempDirectory];
        
        self->_info = [NSDictionary dictionaryWithContentsOfURL:[self.patchFolderURL URLByAppendingPathComponent:@"Info.plist"]];
        
        NSString *zipPath = [self.patchFolderURL URLByAppendingPathComponent:@"patch.zip"].path;
        [SSZipArchive unzipFileAtPath:zipPath toDestination:self.tempDirectoryURL.path progressHandler:nil completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                
                NSArray *folderContents = [self.fileManager contentsOfDirectoryAtURL:self.tempDirectoryURL includingPropertiesForKeys:nil
                                                                             options:NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil];
                for (NSURL *url in folderContents) {
                    [self processLocalizedFolder:url];
                }
            }
            
            [self.fileManager removeItemAtURL:self.tempDirectoryURL error:nil];
            
            self.completion(self);
        }];
    });
}

- (void)createTempDirectory
{
    self.tempDirectoryURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:self.name];
    
    [self.fileManager removeItemAtURL:self.tempDirectoryURL error:nil];
    [self.fileManager createDirectoryAtURL:self.tempDirectoryURL withIntermediateDirectories:YES attributes:nil error:nil];
}

- (void)processLocalizedFolder:(NSURL *)folderURL
{
    NSString *folderName = folderURL.lastPathComponent.stringByDeletingPathExtension;
    if (folderName.length == 0)
        return;
    
    NSArray *folderContents = [self.fileManager contentsOfDirectoryAtURL:folderURL includingPropertiesForKeys:nil
                                                                 options:NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil];
    for (NSURL *url in folderContents) {
        NSDictionary *localizable = [NSDictionary dictionaryWithContentsOfURL:url];
        if (localizable)
            self.localization[folderName] = localizable;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; name: %@; info: %@; localization: %@",
            NSStringFromClass([self class]), self, self.name, self.info, self.localization];
}

@end

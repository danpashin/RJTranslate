//
//  RJTImageCache.m
//  RJTranslate
//
//  Created by Даниил on 28/08/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTImageCache.h"

@interface RJTImageCache ()

@property (strong, nonatomic) NSString *defaultCacheDirectory;
@property (strong, nonatomic) NSCache *memoryCache;

@end

@implementation RJTImageCache
@synthesize defaultCacheDirectory = _defaultCacheDirectory;

+ (instancetype)sharedCache
{
    static RJTImageCache *imageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [RJTImageCache new];
    });
    
    return imageCache;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.memoryCache = [NSCache new];
    }
    return self;
}

- (NSString *)defaultCacheDirectory
{
    if (!_defaultCacheDirectory) {
        NSString *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        
        NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
        _defaultCacheDirectory = [NSString stringWithFormat:@"%@/%@/images/", cacheDirectory, bundleIdentifier];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:_defaultCacheDirectory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_defaultCacheDirectory
                                      withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    return _defaultCacheDirectory;
}

- (nullable UIImage *)objectForKeyedSubscript:(NSString *)key
{
    UIImage *image = [self.memoryCache objectForKey:key];
    if (image)
        return image;
    
    NSString *fullPath = [self.defaultCacheDirectory stringByAppendingString:key];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        image = [UIImage imageWithData:[NSData dataWithContentsOfFile:fullPath]];
        if (image)
            return [UIImage imageWithCGImage:image.CGImage
                                       scale:[UIScreen mainScreen].scale
                                 orientation:image.imageOrientation];
    }
    
    return nil;
}

- (void)setObject:(nullable UIImage *)obj forKeyedSubscript:(NSString *)key
{
    NSString *fullPath = [self.defaultCacheDirectory stringByAppendingString:key];
    
    if (obj) {
        [self.memoryCache setObject:obj forKey:key];
        UIImage *newImage = [UIImage imageWithCGImage:obj.CGImage scale:1.0f
                                          orientation:obj.imageOrientation];
        
        [UIImagePNGRepresentation(newImage) writeToFile:fullPath atomically:YES];
    } else {
        [self.memoryCache removeObjectForKey:key];
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
    }
}

- (void)countSizeWithCompletion:(void(^)(NSUInteger cacheSize))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSURL *folderURL = [NSURL URLWithString:self.defaultCacheDirectory];
        
        NSArray *properties = @[NSURLIsRegularFileKey, NSURLTotalFileAllocatedSizeKey, NSURLFileAllocatedSizeKey];
        NSEnumerator *enumerator = [fileManager enumeratorAtURL:folderURL includingPropertiesForKeys:properties options:0 errorHandler:^BOOL(NSURL * _Nonnull url, NSError * _Nonnull error) {
            return NO;
        }];
        
        NSUInteger totalSize = 0;
        for (NSURL *resourceURL in enumerator) {
            NSNumber *fileResource = nil;
            [resourceURL getResourceValue:&fileResource forKey:NSURLIsRegularFileKey error:nil];
            if (!fileResource.boolValue)
                continue;
            
            NSNumber *fileSize = nil;
            [resourceURL getResourceValue:&fileSize forKey:NSURLTotalFileAllocatedSizeKey error:nil];
            if (fileSize == nil)
                [resourceURL getResourceValue:&fileSize forKey:NSURLFileAllocatedSizeKey error:nil];
            
            totalSize += [fileSize unsignedIntegerValue];
        }
        
        completion(totalSize);
    });
}

- (void)flush
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self.memoryCache removeAllObjects];
        [[NSFileManager defaultManager] removeItemAtPath:self.defaultCacheDirectory error:nil];
        self.defaultCacheDirectory = nil;
    });
}

@end

//
//  RJTImageCache.h
//  RJTranslate
//
//  Created by Даниил on 28/08/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RJTImageCacheType) {
    RJTImageCacheTypeMemory = 0,
    RJTImageCacheTypeMemoryDisk,
    RJTImageCacheTypeDisk
};

@interface RJTImageCache : NSObject

+ (instancetype)sharedCache;

/**
 Тип кэша. По умолчанию, RJTImageCacheTypeMemory
 */
@property (assign, nonatomic) RJTImageCacheType type;

- (nullable UIImage *)objectForKeyedSubscript:(NSString *)key;
- (void)setObject:(nullable UIImage *)obj forKeyedSubscript:(NSString *)key;


/**
 Выполняет подсчет размера кэша.

 @param completion Блок, который вызывется в конце подсчета и содержит размер кэша в байтах.
 */
- (void)countSizeWithCompletion:(void(^)(NSUInteger cacheSize))completion;

/**
 Выполняет очистку кэша в памяти и на диске.
 */
- (void)flush;

@end

NS_ASSUME_NONNULL_END

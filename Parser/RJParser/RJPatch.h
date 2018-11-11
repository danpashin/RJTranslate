//
//  RJPatch.h
//  RJParser_macOS
//
//  Created by Даниил on 10/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJPatch : NSObject

/**
 Имя патча. Берется из имени папки, в которой находится данный патч.
 */
@property (strong, nonatomic, readonly) NSString *name;

/**
 Информация о патче.
 */
@property (strong, nonatomic, nullable, readonly) NSDictionary *info;

/**
 Локализация патча.
 */
@property (strong, nonatomic, readonly) NSMutableDictionary *localization;


- (instancetype)initWithPath:(NSString *)path completion:(void(^)(RJPatch *processedPatch))completion;

- (void)processPatch;

@end

NS_ASSUME_NONNULL_END

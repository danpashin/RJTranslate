//
//  RJPUpdater.h
//  RJParser_macOS
//
//  Created by Даниил on 10/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJPUpdater : NSObject

+ (void)updatePlistAtPath:(NSString *)plistPath withPatchAtPath:(NSString *)patchPath
     argumentsToOverwrite:(NSArray *)argumentsToOverwrite completion:(void(^)(void))completion;

+ (void)updateAllPlistsAtPath:(NSString *)plistsPath withPatchesAtPath:(NSString *)patchesPath
         argumentsToOverwrite:(NSArray *)argumentsToOverwrite completion:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END

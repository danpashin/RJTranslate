//
//  RJParser.h
//  RJParser
//
//  Created by Даниил on 05/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJParser : NSObject

+ (void)parseWithToolsFolder:(NSString *)folderPath
             destinationFolder:(NSString *)destinationFolder
              allowOverwrite:(BOOL)allowOverwrite
                    completion:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END

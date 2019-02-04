//
//  NSSortDescriptor+RJTExtended.h
//  RJTranslate
//
//  Created by Даниил on 04/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSSortDescriptor (RJTExtended)

+ (instancetype)rjt_caseInsWithKey:(NSString *)key ascending:(BOOL)ascending;

@end

NS_ASSUME_NONNULL_END

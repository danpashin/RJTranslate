//
//  NSSortDescriptor+RJTExtended.m
//  RJTranslate
//
//  Created by Даниил on 04/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

#import "NSSortDescriptor+RJTExtended.h"
#import "NSSortDescriptor+RJTExtended.h"

@implementation NSSortDescriptor (RJTExtended)

+ (instancetype)rjt_caseInsWithKey:(NSString *)key ascending:(BOOL)ascending
{
    return [[NSSortDescriptor alloc] initWithKey:key ascending:ascending
                                        selector:@selector(localizedCaseInsensitiveCompare:)];
}

@end

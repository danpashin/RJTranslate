//
//  RJTTranslationEntity.m
//  RJTranslate
//
//  Created by Даниил on 19/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//
//

#import "RJTTranslationEntity.h"

@implementation RJTTranslationEntity
@dynamic bundle_identifier;
@dynamic translation;

+ (NSFetchRequest<RJTTranslationEntity *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"RJTTranslationEntity"];
}

@end

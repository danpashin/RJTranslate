//
//  RJTApplicationEntity.m
//  RJTranslate
//
//  Created by Даниил on 19/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//
//

#import "RJTApplicationEntity.h"

@implementation RJTApplicationEntity
@dynamic bundleIdentifier;
@dynamic translation;
@dynamic enableTranslation;
@dynamic displayedName;
@dynamic executableName;

+ (NSFetchRequest<RJTApplicationEntity *> *)fetchRequest
{
    return [NSFetchRequest fetchRequestWithEntityName:@"RJTApplicationEntity"];
}

@end

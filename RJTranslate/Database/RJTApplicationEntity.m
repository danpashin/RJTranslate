//
//  RJTApplicationEntity.m
//  RJTranslate
//
//  Created by Даниил on 19/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//
//

#import "RJTApplicationEntity.h"
#import <CoreData/NSEntityDescription.h>

#ifdef BUILD_APP
#import <RJTranslate-Swift.h>
#endif

@implementation RJTApplicationEntity
@dynamic bundleIdentifier;
@dynamic translation;
@dynamic enableTranslation;
@dynamic displayedName;
@dynamic executableName;
@dynamic iconPath;
@dynamic executablePath;
@dynamic forceLocalize;
@dynamic remoteUpdated;
@dynamic installDate;

+ (NSFetchRequest<RJTApplicationEntity *> *)fetchRequest
{
    return [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
}

+ (RJTApplicationEntity *)insertIntoContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                         inManagedObjectContext:context];
}

#ifdef BUILD_APP
- (void)copyPropertiesFrom:(TranslationModel *)appModel
{
    self.bundleIdentifier = [appModel.bundleIdentifier copy];
    self.displayedName = [appModel.displayedName copy];
    self.executableName = [appModel.executableName copy];
    self.executablePath = [appModel.executablePath copy];
    self.iconPath = [appModel.iconPath copy];
    
    if (!appModel.lightweightModel) {
        self.translation = [appModel.translation copy];
    }
    
    self.enableTranslation = appModel.enableTranslation;
    self.forceLocalize = appModel.forceLocalize;
}
#endif

@end

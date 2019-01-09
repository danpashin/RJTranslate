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
#import "RJTApplicationModel.h"

@implementation RJTApplicationEntity
@dynamic bundleIdentifier;
@dynamic translation;
@dynamic enableTranslation;
@dynamic displayedName;
@dynamic executableName;
@dynamic icon;
@dynamic executablePath;
@dynamic forceLocalize;

+ (NSFetchRequest<RJTApplicationEntity *> *)fetchRequest
{
    return [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
}

+ (RJTApplicationEntity *)insertIntoContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                         inManagedObjectContext:context];
}

- (void)copyPropertiesFrom:(RJTApplicationModel *)appModel
{
    self.bundleIdentifier = [appModel.bundleIdentifier copy];
    self.displayedName = [appModel.displayedName copy];
    self.executableName = [appModel.executableName copy];
    self.executablePath = [appModel.executablePath copy];
    
    if (!appModel.lightweightModel) {
        self.translation = [appModel.translation copy];
    }
    
    self.enableTranslation = appModel.enableTranslation;
    self.forceLocalize = appModel.forceLocalize;
    
    if (!self.icon)
        self.icon = [RJTAppIconEntity insertIntoContext:self.managedObjectContext];
    
    [self.icon copyPropertiesFrom:appModel.icon];
}

@end

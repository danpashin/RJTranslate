//
//  RJTAppIconEntity.m
//  
//
//  Created by Даниил on 31/10/2018.
//
//

#import "RJTAppIconEntity.h"
#import "RJTAppIcon.h"
#import <CoreData/NSEntityDescription.h>

@implementation RJTAppIconEntity
@dynamic path;
@dynamic base64_encoded;
@dynamic application;
@dynamic primary;

+ (NSFetchRequest<RJTAppIconEntity *> *)fetchRequest
{
	return [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
}

+ (RJTAppIconEntity *)insertIntoContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                         inManagedObjectContext:context];
}


- (void)copyPropertiesFrom:(RJTAppIcon *)appIcon
{
    self.path = [appIcon.path copy];
    self.base64_encoded = [appIcon.base64_encoded copy];
    self.primary = appIcon.primary;
}

@end

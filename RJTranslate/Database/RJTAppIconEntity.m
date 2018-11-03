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

+ (NSFetchRequest<RJTAppIconEntity *> *)fetchRequest
{
	return [NSFetchRequest fetchRequestWithEntityName:@"RJTAppIconEntity"];
}

+ (RJTAppIconEntity *)insertIntoContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"RJTAppIconEntity" inManagedObjectContext:context];
}


- (void)copyPropertiesFrom:(RJTAppIcon *)appIcon
{
    self.path = [appIcon.path copy];
    self.base64_encoded = [appIcon.base64_encoded copy];
}

@end
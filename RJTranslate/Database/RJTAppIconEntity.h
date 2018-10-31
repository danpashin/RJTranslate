//
//  RJTAppIconEntity.h
//  
//
//  Created by Даниил on 31/10/2018.
//
//

#import <CoreData/NSManagedObject.h>
#import <CoreData/NSFetchRequest.h>
@class RJTApplicationEntity, RJTAppIcon;

NS_ASSUME_NONNULL_BEGIN

@interface RJTAppIconEntity : NSManagedObject

+ (NSFetchRequest<RJTAppIconEntity *> *)fetchRequest;
+ (RJTAppIconEntity *)insertIntoContext:(NSManagedObjectContext *)context;

@property (nullable, nonatomic, copy) NSString *path;
@property (nullable, nonatomic, copy) NSString *base64_encoded;

@property (nullable, nonatomic, retain) RJTApplicationEntity *application;

- (void)copyPropertiesFrom:(RJTAppIcon *)appIcon;

@end

NS_ASSUME_NONNULL_END

//
//  RJTApplicationEntity.h
//  RJTranslate
//
//  Created by Даниил on 19/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//
//

#import "RJTAppIconEntity.h"
@class NSObject, RJTApplicationModel;


NS_ASSUME_NONNULL_BEGIN

@interface RJTApplicationEntity : NSManagedObject

+ (NSFetchRequest<RJTApplicationEntity *> *)fetchRequest;
+ (RJTApplicationEntity *)insertIntoContext:(NSManagedObjectContext *)context;

@property (nullable, nonatomic, copy) NSString *displayedName;
@property (nullable, nonatomic, copy) NSString *bundleIdentifier;
@property (nullable, nonatomic, copy) NSString *executableName;

@property (nullable, nonatomic, retain) NSDictionary *translation;
@property (assign, nonatomic) BOOL enableTranslation;

@property (nullable, nonatomic, retain) RJTAppIconEntity *icon;

- (void)copyPropertiesFrom:(RJTApplicationModel *)appModel;

@end

NS_ASSUME_NONNULL_END

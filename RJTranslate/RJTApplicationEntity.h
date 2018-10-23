//
//  RJTApplicationEntity.h
//  RJTranslate
//
//  Created by Даниил on 19/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//
//

#import <CoreData/NSManagedObject.h>
#import <CoreData/NSFetchRequest.h>

@class NSObject;

NS_ASSUME_NONNULL_BEGIN

@interface RJTApplicationEntity : NSManagedObject

+ (NSFetchRequest<RJTApplicationEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *displayedName;
@property (nullable, nonatomic, copy) NSString *bundleIdentifier;
@property (nullable, nonatomic, copy) NSString *executableName;

@property (nullable, nonatomic, retain) NSDictionary *translation;
@property (assign, nonatomic) BOOL enableTranslation;

@end

NS_ASSUME_NONNULL_END

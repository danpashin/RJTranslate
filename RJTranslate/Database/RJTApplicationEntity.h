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
@class NSObject, TranslationModel;


NS_ASSUME_NONNULL_BEGIN

@interface RJTApplicationEntity : NSManagedObject

+ (NSFetchRequest<RJTApplicationEntity *> *)fetchRequest;
+ (RJTApplicationEntity *)insertIntoContext:(NSManagedObjectContext *)context;

@property (nonatomic, copy) NSString *displayedName;
@property (nullable, nonatomic, copy) NSString *bundleIdentifier;
@property (nullable, nonatomic, copy) NSString *executableName;
@property (nullable, nonatomic, copy) NSString *executablePath;

@property (nullable, nonatomic, retain) NSDictionary <NSString *, NSString *> *translation;
@property (assign, nonatomic) BOOL enableTranslation;
@property (assign, nonatomic) BOOL forceLocalize;

@property (nullable, nonatomic, retain) NSString *iconPath;

@property (assign, nonatomic) double remoteUpdated;
@property (assign, nonatomic) double installDate;

#ifdef BUILD_APP
- (void)copyPropertiesFrom:(TranslationModel *)appModel;
#endif

@end

NS_ASSUME_NONNULL_END

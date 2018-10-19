//
//  RJTTranslationEntity.h
//  RJTranslate
//
//  Created by Даниил on 19/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSObject;

NS_ASSUME_NONNULL_BEGIN

@interface RJTTranslationEntity : NSManagedObject

+ (NSFetchRequest<RJTTranslationEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bundle_identifier;
@property (nullable, nonatomic, retain) NSDictionary *translation;

@end

NS_ASSUME_NONNULL_END

#import "Translation+CoreDataProperties.h"

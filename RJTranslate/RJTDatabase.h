//
//  RJTDatabase.h
//  RJTranslate
//
//  Created by Даниил on 19/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/NSPersistentContainer.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJTDatabase : NSPersistentContainer

+ (instancetype)defaultDatabase;

- (void)save;
- (void)saveContext:(NSManagedObjectContext *)context;
@end

NS_ASSUME_NONNULL_END

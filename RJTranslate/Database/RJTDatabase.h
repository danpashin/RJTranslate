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

@interface RJTDatabase : NSObject

/**
 Загружает базу данных и локальное хранилище.

 @return Возвращает экземпляр класса для работы с базой.
 */
+ (instancetype _Nullable)defaultDatabase;


@property (assign, nonatomic, readonly) BOOL readOnly;

- (void)saveContext:(NSManagedObjectContext *)context;

- (void)saveBackgroundContext;

- (void)performBackgroundTask:(void (^)(NSManagedObjectContext * _Nonnull))block;

@property (strong, readonly) NSManagedObjectContext *viewContext NS_UNAVAILABLE;
- (NSManagedObjectContext *)newBackgroundContext NS_RETURNS_RETAINED NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END

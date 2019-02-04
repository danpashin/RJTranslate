//
//  RJTDatabaseFacade.m
//  RJTranslate
//
//  Created by Даниил on 07/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

#import "RJTDatabaseFacade.h"
#import "RJTDatabase.h"

#import "RJTApplicationEntity.h"
#import "NSSortDescriptor+RJTExtended.h"

@implementation RJTDatabaseFacade

- (instancetype)init
{
    self = [super init];
    if (self) {
        _database = [RJTDatabase defaultDatabase];
    }
    return self;
}

- (void)forceSaveContext
{
    [self.database saveContext];
}

- (void)fetchAppEntitiesWithPredicate:(NSPredicate * _Nullable)predicate
                           completion:(void (^)(NSArray<RJTApplicationEntity *> * _Nonnull entities))completion
{
    [self.database performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
        NSFetchRequest *fetchRequest = [RJTApplicationEntity fetchRequest];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor rjt_caseInsWithKey:@"displayedName" ascending:YES]];
        fetchRequest.predicate = predicate;
        
        NSArray <RJTApplicationEntity *> *result = [context executeFetchRequest:fetchRequest error:nil];
        completion(result ?: @[]);
    }];
}

- (void)purgeWithCompletion:(void(^_Nullable)(void))completion
{
    [self.database performBackgroundTask:^(NSManagedObjectContext * _Nonnull context) {
        NSFetchRequest *fetchRequest = [RJTApplicationEntity fetchRequest];
        NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
        [context executeRequest:deleteRequest error:nil];
        
        if (completion)
            completion();
    }];
}

@end

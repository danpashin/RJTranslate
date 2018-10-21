//
//  RJTDatabase.m
//  RJTranslate
//
//  Created by Даниил on 19/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTDatabase.h"
#import <CoreData/CoreData.h>

@interface RJTDatabase ()

@end

@implementation RJTDatabase
@dynamic viewContext;

+ (NSURL *)defaultDirectoryURL
{
#if !defined(BUILD_TWEAK) && (defined(__arm__) || defined(__arm64__))
    return [super defaultDirectoryURL];
#else
    return [NSURL fileURLWithPath:@"/var/mobile/Library/Preferences/"];
#endif
}

+ (NSURL *)defaultModelURL
{
    NSString *appSupportPath = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSLocalDomainMask, YES).firstObject;
    NSURL *url = [NSURL fileURLWithPath:[appSupportPath stringByAppendingString:@"/RJTranslate.bundle/RJTranslate.momd"]
                            isDirectory:YES];
    
    return url;
}

+ (instancetype)defaultDatabase
{
    __block RJTDatabase *defaultDatabase = nil;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_sync(queue, ^{
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.defaultModelURL];
        if (!model)
            return;
        defaultDatabase = [[RJTDatabase alloc] initWithName:@"RJTranslate"
                                         managedObjectModel:model];

        [defaultDatabase loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull description, NSError * _Nullable error) {}];
    });
    
    return defaultDatabase;
}

- (void)save
{
    [self saveContext:self.viewContext];
}

- (void)saveContext:(NSManagedObjectContext *)context
{
    NSError *error = nil;
    
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error while saving context: %@, %@", error, error.userInfo);
        abort();
    } else {
        NSLog(@"SAVED!!!");
    }
}


@end

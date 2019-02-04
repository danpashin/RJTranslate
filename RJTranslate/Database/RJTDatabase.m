//
//  RJTDatabase.m
//  RJTranslate
//
//  Created by Даниил on 19/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTDatabase.h"
#import "RJTOperationQueue.h"

@interface RJTDatabase ()
@property (strong, nonatomic) RJTOperationQueue *operationsQueue;
@property (strong, nonatomic) dispatch_queue_t serialBackgroundQueue;

@property (assign, nonatomic) BOOL wasLoadedSuccessfully;


@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *psCoordinator;

@property (strong, nonatomic) NSManagedObjectContext *backgroundContext;
@end

@implementation RJTDatabase

+ (NSURL *)defaultDirectoryURL
{
#if defined(BUILD_TWEAK)
    NSString *documentsPath = @"/var/mobile/Library/Preferences/RJTranslate/";
#else
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    documentsPath = [documentsPath stringByAppendingString:@"/RJTranslate/"];
#endif
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    return [NSURL fileURLWithPath:documentsPath];
}

+ (NSURL *)defaultModelURL
{
#if !defined(BUILD_TWEAK)
    return [[NSBundle mainBundle] URLForResource:@"RJTranslate" withExtension:@"momd"];
#else
    NSString *appSupportPath = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSLocalDomainMask, YES).firstObject;
    NSURL *url = [NSURL fileURLWithPath:[appSupportPath stringByAppendingString:@"/RJTranslate.bundle/RJTranslate.momd"]
                            isDirectory:YES];
    
    return url;
#endif
}

+ (instancetype _Nullable)defaultDatabase
{
    __block RJTDatabase *defaultDatabase = nil;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_sync(queue, ^{
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.defaultModelURL];
        if (!model)
            return;
        
        defaultDatabase = [[RJTDatabase alloc] initWithName:@"RJTranslate" managedObjectModel:model];
    });
    
    return defaultDatabase;
}

- (instancetype)initWithName:(NSString *)name managedObjectModel:(NSManagedObjectModel *)model
{
    self = [super init];
    if (self) {
        self.name = name;
        self.managedObjectModel = model;
        
        self.operationsQueue = [RJTOperationQueue new];
        self.operationsQueue.name = @"ru.danpashin.rjtranslate.coredata.operations";
        self.operationsQueue.qualityOfService = NSQualityOfServiceUtility;
        self.serialBackgroundQueue = dispatch_queue_create("ru.danpashin.rjtranslate.database.serial", DISPATCH_QUEUE_SERIAL);
        
        
        self.psCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        self.backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        self.backgroundContext.persistentStoreCoordinator = self.psCoordinator;
        self.backgroundContext.stalenessInterval = 0.0f;
        
        [self loadPersistentStore];
    }
    return self;
}

- (void)loadPersistentStore
{
    dispatch_async(self.serialBackgroundQueue, ^{
        NSURL *persistentStoreFolderURL = [self.class defaultDirectoryURL];
        self->_readOnly = ![[NSFileManager defaultManager] isWritableFileAtPath:persistentStoreFolderURL.path];
        
        NSDictionary *loadingOptions = @{NSReadOnlyPersistentStoreOption:@(self.readOnly),
                                         NSMigratePersistentStoresAutomaticallyOption:@YES,
                                         NSInferMappingModelAutomaticallyOption:@YES};
        
        NSError *loadingError = nil;
        NSString *databaseName = [self.name stringByAppendingString:@".sqlite"];
        NSURL *databaseURL = [persistentStoreFolderURL URLByAppendingPathComponent:databaseName];
        [self.psCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                         configuration:nil
                                                   URL:databaseURL
                                               options:loadingOptions
                                                 error:&loadingError];
        
        RJTLog(@"Loaded persistent store read-only: %@; with error: %@", @(self.readOnly), loadingError);
        
        if (!loadingError) {
            [self.operationsQueue startAllPending];
        }
        
        self.wasLoadedSuccessfully = !loadingError;
    });
}

- (void)performBackgroundTask:(void (^)(NSManagedObjectContext * _Nonnull))block
{
    [self.operationsQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        block(self.backgroundContext);
    }] startImmediately:self.wasLoadedSuccessfully];
}

- (void)saveContext
{
    dispatch_async(self.serialBackgroundQueue, ^{
        if (self.readOnly) {
            RJTErrorLog(nil, @"Persistent store is read-only. Skipping saving.");
            return;
        }
        
        NSError *error = nil;
        if (![self.backgroundContext save:&error]) {
            RJTErrorLog(error, @"Error while saving context: %@, %@", error, error.userInfo);
        }
    });
}

@end

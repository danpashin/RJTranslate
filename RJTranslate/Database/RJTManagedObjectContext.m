//
//  RJTManagedObjectContext.m
//  RJTranslate
//
//  Created by Даниил on 04/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTManagedObjectContext.h"
#import <UIKit/UIKit.h>

@interface RJTManagedObjectContext ()
@property (assign, nonatomic) NSInteger saveRequestsCount;
@end

@implementation RJTManagedObjectContext

- (instancetype)initWithConcurrencyType:(NSManagedObjectContextConcurrencyType)ct
{
    self = [super initWithConcurrencyType:ct];
    if (self) {
        self.saveRequestsCount = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationStateDidChange)
                                                     name:UIApplicationWillResignActiveNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationStateDidChange)
                                                     name:UIApplicationWillTerminateNotification object:nil];
    }
    
    return self;
}

- (BOOL)save:(NSError * _Nullable __autoreleasing *)error
{
    self.saveRequestsCount++;
    if (self.saveRequestsCount < 5)
        return YES;
    
    self.saveRequestsCount = 0;
    
    return [super save:error];
}

- (BOOL)forceSave:(NSError * _Nullable __autoreleasing *)error
{
    return [super save:error];
}

- (void)applicationStateDidChange
{
    if (self.hasChanges)
        [self forceSave:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

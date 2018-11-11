//
//  RJTCollectionViewDataSource.m
//  RJTranslate-App
//
//  Created by Даниил on 08/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTCollectionViewDataSource.h"

@implementation RJTCollectionViewDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.installedAppsModels = [NSMutableArray array];
        self.uninstalledAppsModels = [NSMutableArray array];
    }
    return self;
}

- (NSSet *)allObjects
{
    NSMutableSet *allObjects = [[NSMutableSet alloc] initWithArray:self.installedAppsModels];
    [allObjects addObjectsFromArray:self.uninstalledAppsModels];
    
    return allObjects;
}

- (void)removeAll
{
    [self.installedAppsModels removeAllObjects];
    [self.uninstalledAppsModels removeAllObjects];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; installed %@; uninstalled %@>",
            NSStringFromClass([self class]), self, self.installedAppsModels, self.uninstalledAppsModels];
}

@end

//
//  RJTCollectionViewDataSource.m
//  RJTranslate-App
//
//  Created by Даниил on 08/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTCollectionViewDataSource.h"
#import "RJTApplicationModel.h"

@implementation RJTCollectionViewDataSource

- (instancetype)initWithModels:(NSArray<RJTApplicationModel *> *)appModels
{
    self = [super init];
    if (self) {
        _rawModels = appModels;
        
        NSMutableArray *installedAppsModels = [NSMutableArray array];
        _installedAppsModels = installedAppsModels;
        
        NSMutableArray *uninstalledAppsModels = [NSMutableArray array];
        _uninstalledAppsModels = uninstalledAppsModels;
        
        [appModels enumerateObjectsUsingBlock:^(RJTApplicationModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.appInstalled) {
                [installedAppsModels addObject:obj];
            } else {
                [uninstalledAppsModels addObject:obj];
            }
        }];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithModels:@[]];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    return [self initWithModels:@[]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; installed %@; uninstalled %@>",
            NSStringFromClass([self class]), self, self.installedAppsModels, self.uninstalledAppsModels];
}

@end

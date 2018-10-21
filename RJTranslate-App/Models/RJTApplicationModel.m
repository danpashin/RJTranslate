//
//  RJTApplicationModel.m
//  RJTranslate-App
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTApplicationModel.h"
#import "RJTApplicationEntity.h"

@interface RJTApplicationModel ()

@property (strong, nonatomic, readwrite, nullable) NSString *app_name;
@property (strong, nonatomic, readwrite, nullable) NSString *bundle_identifier;
@property (strong, nonatomic, readwrite, nullable) NSDictionary *translation;
@property (assign, nonatomic, readwrite) BOOL enableTranslation;

@end

@implementation RJTApplicationModel

+ (instancetype)from:(RJTApplicationEntity *)entity
{
    RJTApplicationModel *model = [RJTApplicationModel new];
    model.app_name = [entity.app_name copy];
    model.bundle_identifier = [entity.bundle_identifier copy];
    model.translation = [entity.translation copy];
    model.enableTranslation = entity.enableTranslation;
    
    return model;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> name: '%@' (%@), enable translation: %@",
            NSStringFromClass([self class]), self, self.app_name, self.bundle_identifier, @(self.enableTranslation)];
}

@end

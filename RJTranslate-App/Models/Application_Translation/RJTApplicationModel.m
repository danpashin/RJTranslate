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

@property (strong, nonatomic, readwrite, nullable) NSString *displayedName;
@property (strong, nonatomic, readwrite, nullable) NSString *bundleIdentifier;
@property (strong, nonatomic, readwrite, nullable) NSString *executableName;
@property (strong, nonatomic, readwrite, nullable) NSString *executablePath;

@property (strong, nonatomic, readwrite, nullable) NSDictionary *translation;
@property (strong, nonatomic, readwrite, nullable) RJTAppIcon *icon;

@property (assign, nonatomic, readwrite) BOOL forceLocalize;

@end

@implementation RJTApplicationModel

static NSString *const kRJTDisplayedNameKey = @"Displayed Name";
static NSString *const kRJTBundleIdentifierKey = @"Bundle Identifier";
static NSString *const kRJTExecutableNameKey = @"Executable Name";
static NSString *const kRJTExecutablePathKey = @"Executable Path";

static NSString *const kRJTTranslationsKey = @"Translations";
static NSString *const kRJTIconKey = @"Icon";

static NSString *const kRJTForceLocalizeKey = @"forceLocalize";

+ (instancetype)copyFromEntity:(RJTApplicationEntity *)entity
{
    RJTApplicationModel *model = [RJTApplicationModel new];
    model.displayedName = [entity.displayedName copy];
    model.bundleIdentifier = [entity.bundleIdentifier copy];
    model.executableName = [entity.executableName copy];
    model.executablePath = [entity.executablePath copy];
    
    model.translation = [entity.translation copy];
    model.enableTranslation = entity.enableTranslation;
    model.forceLocalize = entity.forceLocalize;
    
    model.icon = [RJTAppIcon copyFromEntity:entity.icon appModel:model];
    
    return model;
}

+ (instancetype)from:(NSDictionary *)dictionary
{
    if (![dictionary[kRJTDisplayedNameKey] isKindOfClass:[NSString class]])
        return nil;
    
    RJTApplicationModel *model = [RJTApplicationModel new];
    model.displayedName = dictionary[kRJTDisplayedNameKey];
    model.bundleIdentifier = dictionary[kRJTBundleIdentifierKey];
    model.executableName = dictionary[kRJTExecutableNameKey];
    model.executablePath = dictionary[kRJTExecutablePathKey];
    
    model.translation = dictionary[kRJTTranslationsKey];
    model.icon = [RJTAppIcon from:dictionary[kRJTIconKey] appModel:model];
    
    model.forceLocalize = [dictionary[kRJTForceLocalizeKey] boolValue];
    
    return model;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> name: '%@' (%@ - %@), enable translation: %@",
            NSStringFromClass([self class]), self, self.displayedName, self.executableName,
            self.bundleIdentifier, @(self.enableTranslation)];
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[self class]])
        return NO;
    
    RJTApplicationModel *model = object;
    if (![model.displayedName isEqualToString:self.displayedName])
        return NO;
    
    return YES;
}

@end

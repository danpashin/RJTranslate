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
@property (strong, nonatomic, readwrite, nullable) NSString *iconPath;

@property (assign, nonatomic, readwrite) BOOL forceLocalize;

@property (assign, nonatomic, readwrite) BOOL appInstalled;

@property (assign, nonatomic, readwrite) BOOL lightweightModel;

@end

@implementation RJTApplicationModel

static NSString *const kRJTDisplayedNameKey = @"Displayed Name";
static NSString *const kRJTBundleIdentifierKey = @"Bundle Identifier";
static NSString *const kRJTExecutableNameKey = @"Executable Name";
static NSString *const kRJTExecutablePathKey = @"Executable Path";

static NSString *const kRJTTranslationsKey = @"Translations";
static NSString *const kRJTIconPathKey = @"Icon";

static NSString *const kRJTForceLocalizeKey = @"Force";

+ (instancetype)copyFromEntity:(RJTApplicationEntity *)entity
{
    return [self copyFromEntity:entity lightweight:NO];
}

+ (instancetype)copyFromEntity:(RJTApplicationEntity *)entity lightweight:(BOOL)lightweight
{
    RJTApplicationModel *model = [RJTApplicationModel new];
    model.displayedName = [entity.displayedName copy];
    model.bundleIdentifier = [entity.bundleIdentifier copy];
    model.executableName = [entity.executableName copy];
    model.executablePath = [entity.executablePath copy];
    
    model.lightweightModel = lightweight;
    if (!lightweight) {
        model.translation = [entity.translation copy];
    }
    
    model.enableTranslation = entity.enableTranslation;
    model.forceLocalize = entity.forceLocalize;
    
    return model;
}

+ (instancetype)from:(NSDictionary *)dictionary
{
    NSLog(@"Creating model from: %@", dictionary);
    if (![dictionary[kRJTDisplayedNameKey] isKindOfClass:[NSString class]])
        return nil;
    
    RJTApplicationModel *model = [RJTApplicationModel new];
    model.displayedName = dictionary[kRJTDisplayedNameKey];
    model.bundleIdentifier = dictionary[kRJTBundleIdentifierKey];
    model.executableName = dictionary[kRJTExecutableNameKey];
    model.executablePath = dictionary[kRJTExecutablePathKey];
    
    model.iconPath = dictionary[kRJTIconPathKey];
    
    model.forceLocalize = [dictionary[kRJTForceLocalizeKey] boolValue];
    
    NSMutableDictionary *translation = [NSMutableDictionary dictionary];
    for (NSDictionary *translatedLine in dictionary[kRJTTranslationsKey]) {
        NSString *original = translatedLine[@"key"];
        NSString *translated = translatedLine[@"string"];
        if (!original || !translated)
            continue;
        
        translation[original] = translated;
    }
    model.translation = translation;
    
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

- (BOOL)appInstalled
{
    if (self.executablePath.length > 0) {
        return (access(self.executablePath.UTF8String, F_OK) == 0);
    } else if (self.bundleIdentifier.length > 0) {
        return [NSBundle bundleWithIdentifier:self.bundleIdentifier] ? YES : NO;
    }
    
    return NO;
}

@end

//
//  RJTPrefsOption.m
//  RJTranslate-App
//
//  Created by Даниил on 14/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTPrefsOption.h"
#import "RJTPrefsTableModel.h"

@interface RJTPrefsOption ()
@property (strong, nonatomic) id defaultValue;
@end

@implementation RJTPrefsOption

+ (instancetype)staticTextOptionWithTitle:(NSString *)title subtitle:(NSString * _Nullable)subtitle
{
    return [[self alloc] initWithType:RJTPrefsOptionTypeStaticText key:nil defaultValue:nil title:title susbtitle:subtitle];
}

+ (instancetype)switchOptionWithTitle:(NSString *)title key:(NSString *)key defaultValue:(id)defaultValue
{
    return [[self alloc] initWithType:RJTPrefsOptionTypeSwitch key:key defaultValue:defaultValue title:title susbtitle:nil];
}


- (instancetype)init
{
    return [self initWithType:RJTPrefsOptionTypeStaticText key:nil defaultValue:nil title:@"" susbtitle:nil];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    return [self initWithType:RJTPrefsOptionTypeStaticText key:nil defaultValue:nil title:@"" susbtitle:nil];
}

- (instancetype)initWithType:(RJTPrefsOptionType)type key:(NSString * _Nullable)key defaultValue:(id)defaultValue
                       title:(NSString *)title susbtitle:(NSString * _Nullable)subtitle
{
    self = [super init];
    if (self) {
        _type = type;
        _key = key;
        _title = title;
        _subtitle = subtitle;
        _defaultValue = defaultValue;
        
    }
    return self;
}

- (nullable id)savedValue
{
    if (!self.key)
        return self.defaultValue;
    
    id savedValue = [[NSUserDefaults standardUserDefaults] objectForKey:self.key];
    
    return savedValue ?: self.defaultValue;
}

- (void)saveValue:(nullable id)value
{
    [self performOnBackground:^{
        if (!self.key) {
            RJTErrorLog(nil, @"Can not save preference value %@ because key is nil", value);
            return;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:self.key];
        
        [self.prefsTableModel.delegate userDidSetPreferenceValue:value forKey:self.key];
    }];
}

- (void)performOnBackground:(void(^)(void))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), block);
}

@end

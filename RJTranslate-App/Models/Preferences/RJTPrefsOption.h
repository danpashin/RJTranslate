//
//  RJTPrefsOption.h
//  RJTranslate-App
//
//  Created by Даниил on 14/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RJTPrefsTableModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RJTPrefsOptionType) {
    RJTPrefsOptionTypeSection,
    RJTPrefsOptionTypeStaticText,
    RJTPrefsOptionTypeSwitch
};

@interface RJTPrefsOption : NSObject

+ (instancetype)staticTextOptionWithTitle:(NSString *)title subtitle:(NSString * _Nullable)subtitle;
+ (instancetype)switchOptionWithTitle:(NSString *)title key:(NSString *)key defaultValue:(nullable id)defaultValue;

@property (weak, nonatomic) RJTPrefsTableModel *prefsTableModel;

@property (assign, nonatomic, readonly) RJTPrefsOptionType type;
@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSString *subtitle;
@property (strong, nonatomic, readonly) NSString *key;

@property (nonatomic, readonly, nullable) id savedValue;

- (void)saveValue:(nullable id)value;

- (void)performOnBackground:(void(^)(void))block;

- (instancetype)initWithType:(RJTPrefsOptionType)type key:(NSString * _Nullable)key defaultValue:(nullable id)defaultValue
                       title:(NSString *)title susbtitle:(NSString * _Nullable)subtitle NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

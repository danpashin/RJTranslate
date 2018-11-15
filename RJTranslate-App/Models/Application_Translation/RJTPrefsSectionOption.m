//
//  RJTPrefsSectionOption.m
//  RJTranslate-App
//
//  Created by Даниил on 14/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTPrefsSectionOption.h"

@interface RJTPrefsSectionOption ()
@property (strong, nonatomic, readwrite) NSArray <RJTPrefsOption *> *rows;
@end

@implementation RJTPrefsSectionOption

+ (instancetype)sectionWithHeaderTitle:(NSString * _Nullable)headerTitle
                            footerText:(NSString * _Nullable)footerText
                                  rows:(NSArray <RJTPrefsOption *> *)rows
{
    return [[self alloc] initWithTitle:headerTitle footerText:footerText rows:rows];
}

- (instancetype)initWithTitle:(NSString *)title footerText:(NSString *)footerText rows:(NSArray <RJTPrefsOption *> *)rows
{
    self = [super init];
    if (self) {
        _title = title;
        _footerText = footerText;
        _rows = rows;
    }
    return self;
}

@end

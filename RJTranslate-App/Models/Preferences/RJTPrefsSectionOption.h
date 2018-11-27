//
//  RJTPrefsSectionOption.h
//  RJTranslate-App
//
//  Created by Даниил on 14/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTPrefsOption.h"

NS_ASSUME_NONNULL_BEGIN

@interface RJTPrefsSectionOption : NSObject

+ (instancetype)sectionWithHeaderTitle:(NSString * _Nullable)headerTitle
                            footerText:(NSString * _Nullable)footerText
                                  rows:(NSArray <RJTPrefsOption *> *)rows;

@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSString *footerText;
@property (strong, nonatomic, readonly) NSArray <RJTPrefsOption *> *rows;

@end

NS_ASSUME_NONNULL_END

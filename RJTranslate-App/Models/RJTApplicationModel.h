//
//  RJTApplicationModel.h
//  RJTranslate-App
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RJTApplicationEntity;

NS_ASSUME_NONNULL_BEGIN

@interface RJTApplicationModel : NSObject

+ (instancetype)from:(RJTApplicationEntity *)entity;

@property (strong, nonatomic, readonly, nullable) NSString *app_name;
@property (strong, nonatomic, readonly, nullable) NSString *bundle_identifier;
@property (strong, nonatomic, readonly, nullable) NSDictionary *translation;
@property (assign, nonatomic, readonly) BOOL enableTranslation;

@end

NS_ASSUME_NONNULL_END

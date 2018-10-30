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

+ (RJTApplicationModel *)copyFromEntity:(RJTApplicationEntity *)entity;

+ (RJTApplicationModel * _Nullable)from:(NSDictionary *)dictionary;

@property (strong, nonatomic, readonly, nullable) NSString *displayedName;
@property (strong, nonatomic, readonly, nullable) NSString *bundleIdentifier;
@property (strong, nonatomic, readonly, nullable) NSString *executableName;
@property (strong, nonatomic, readonly, nullable) NSDictionary *translation;
@property (assign, nonatomic) BOOL enableTranslation;

@end

NS_ASSUME_NONNULL_END

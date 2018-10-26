//
//  RJTAPI.h
//  RJTranslate-App
//
//  Created by Даниил on 26/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RJTAPIRequest;

NS_ASSUME_NONNULL_BEGIN

@interface RJTAPI : NSObject

+ (instancetype)sharedAPI;

@property (strong, nonatomic, class, readonly) NSURL *apiURL;

@property (strong, nonatomic, readonly) NSURLSessionConfiguration *configuration;

- (void)addRequest:(RJTAPIRequest *)request;

@end

NS_ASSUME_NONNULL_END

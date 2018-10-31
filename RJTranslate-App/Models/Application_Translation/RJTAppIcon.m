//
//  RJTAppIcon.m
//  RJTranslate
//
//  Created by Даниил on 31/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTAppIcon.h"
#import "RJTApplicationModel.h"
#import "UIImage+Private.h"

@interface RJTAppIcon ()

@property (strong, nonatomic, nullable, readwrite) NSString *path;
@property (strong, nonatomic, nullable, readwrite) NSString *base64_encoded;

@end

@implementation RJTAppIcon
static NSString *const kRJTIconPathKey = @"path";
static NSString *const kRJTIconBase64Key = @"base64";

+ (RJTAppIcon *)from:(NSDictionary *)dictionary
{
    RJTAppIcon *appIcon = [RJTAppIcon new];
    appIcon.path = dictionary[kRJTIconPathKey];
    appIcon.base64_encoded = dictionary[kRJTIconBase64Key];
    
    return appIcon;
}

+ (RJTAppIcon *)copyFromEntity:(RJTAppIconEntity *)entity
{
    RJTAppIcon *appIcon = [RJTAppIcon new];
    appIcon.path = entity.path;
    appIcon.base64_encoded = entity.base64_encoded;
    
    return appIcon;
}

- (UIImage * _Nullable)image
{
    UIImage *image = nil;
    
    if (self.path.length > 0) {
        image = [UIImage imageWithContentsOfFile:self.path];
    } else if (self.base64_encoded.length > 0) {
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:self.base64_encoded options:0];
        image = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
    }
    
    if (!image && self.appModel.bundleIdentifier.length > 0) {
       image = [UIImage _applicationIconImageForBundleIdentifier:self.appModel.bundleIdentifier
                                                          format:MIIconVariantDefault
                                                           scale:[UIScreen mainScreen].scale];
    }
    
    return image;
}

@end

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

@property (weak, nonatomic) RJTApplicationModel *appModel;

@end

@implementation RJTAppIcon
static NSString *const kRJTIconPathKey = @"path";
static NSString *const kRJTIconBase64Key = @"base64";

+ (RJTAppIcon *)from:(NSDictionary * _Nullable)dictionary appModel:(RJTApplicationModel * _Nullable)appModel
{
    RJTAppIcon *appIcon = [RJTAppIcon new];
    appIcon.path = dictionary[kRJTIconPathKey];
    appIcon.base64_encoded = dictionary[kRJTIconBase64Key];
    
    return appIcon;
}

+ (RJTAppIcon *)copyFromEntity:(RJTAppIconEntity *)entity appModel:(RJTApplicationModel * _Nullable)appModel
{
    RJTAppIcon *appIcon = [RJTAppIcon new];
    appIcon.path = entity.path;
    appIcon.base64_encoded = entity.base64_encoded;
    appIcon.appModel = appModel;
    
    return appIcon;
}

- (UIImage * _Nullable)image
{
    UIImage *image = nil;
    
    if (self.path.length > 0) {
        if ([self.path.lowercaseString containsString:@"bundle"]) {
            NSString *bundlePath = [self.path stringByDeletingLastPathComponent];
            NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
            
            NSString *imageName = [self.path.lastPathComponent stringByDeletingPathExtension];
            imageName = [imageName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
            imageName = [imageName stringByReplacingOccurrencesOfString:@"@3x" withString:@""];
            
            image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
        }
        
        if (!image)
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

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
#import "RJTImageCache.h"

@interface RJTAppIcon ()

@property (strong, nonatomic, nullable, readwrite) NSString *path;
@property (strong, nonatomic, nullable, readwrite) NSString *base64_encoded;
@property (assign, nonatomic, readwrite) BOOL primary;

@property (weak, nonatomic) RJTApplicationModel *appModel;

@end

@implementation RJTAppIcon
static NSString *const kRJTIconPathKey = @"path";
static NSString *const kRJTIconBase64Key = @"base64";
static NSString *const kRJTIconPrimaryKey = @"Primary";

+ (RJTAppIcon *)from:(NSDictionary * _Nullable)dictionary appModel:(RJTApplicationModel * _Nullable)appModel
{
    RJTAppIcon *appIcon = [RJTAppIcon new];
    appIcon.path = dictionary[kRJTIconPathKey];
    appIcon.base64_encoded = dictionary[kRJTIconBase64Key];
    appIcon.primary = [dictionary[kRJTIconPrimaryKey] boolValue];
    
    return appIcon;
}

+ (RJTAppIcon *)copyFromEntity:(RJTAppIconEntity * _Nullable)entity appModel:(RJTApplicationModel * _Nullable)appModel
{
    RJTAppIcon *appIcon = [RJTAppIcon new];
    appIcon.path = entity.path;
    appIcon.base64_encoded = entity.base64_encoded;
    appIcon.appModel = appModel;
    appIcon.primary = entity.primary;
    
    return appIcon;
}

- (void)loadIconWithCompletion:(void(^)(UIImage * _Nullable iconImage))completion
{
    dispatch_queue_t queue = dispatch_queue_create("ru.danpashin.rjtranslate.image", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        RJTImageCache *imageCache = [RJTImageCache sharedCache];
        UIImage *image = imageCache[self.appModel.displayedName];
        if (image) {
            completion(image);
            return;
        }
        
        UIImage *icon = nil;
        if (self.primary) {
            icon = self.customIcon ?: self.systemIcon;
        } else {
            icon = self.systemIcon ?: self.customIcon;
        }
        
        completion(icon);
    });
}


- (UIImage * _Nullable)systemIcon
{
    if (self.appModel.bundleIdentifier.length > 0)
        return [UIImage _applicationIconImageForBundleIdentifier:self.appModel.bundleIdentifier
                                                           format:MIIconVariantDefault
                                                            scale:[UIScreen mainScreen].scale];
    
    return nil;
}

- (UIImage * _Nullable)customIcon
{
    UIImage *icon = nil;
    if (self.path.length > 0) {
        if ([self.path.lowercaseString containsString:@"bundle"]) {
            NSString *bundlePath = [self.path stringByDeletingLastPathComponent];
            NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
            
            NSString *imageName = [self.path.lastPathComponent stringByDeletingPathExtension];
            imageName = [imageName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
            imageName = [imageName stringByReplacingOccurrencesOfString:@"@3x" withString:@""];
            
            icon = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
        }
        
        if (!icon)
            icon = [UIImage imageWithContentsOfFile:self.path];
    } else if (self.base64_encoded.length > 0) {
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:self.base64_encoded options:0];
        icon = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
    }
    
    return icon;
}

@end

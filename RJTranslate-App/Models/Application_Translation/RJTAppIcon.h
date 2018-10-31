//
//  RJTAppIcon.h
//  RJTranslate
//
//  Created by Даниил on 31/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RJTAppIconEntity.h"
@class RJTApplicationModel;

NS_ASSUME_NONNULL_BEGIN

@interface RJTAppIcon : NSObject

+ (RJTAppIcon *)copyFromEntity:(RJTAppIconEntity *)entity;

+ (RJTAppIcon *)from:(NSDictionary *)dictionary;

/**
 Путь к изображению в файловой системе.
 */
@property (strong, nonatomic, nullable, readonly) NSString *path;

/**
 Изображение в формате base64.
 */
@property (strong, nonatomic, nullable, readonly) NSString *base64_encoded;

/**
 Создает изображение из доступных данных: файла либо base64 строке. Не потокобезопасно.
 */
@property (strong, nonatomic, readonly, nullable) UIImage *image;


@property (weak, nonatomic) RJTApplicationModel *appModel;

@end

NS_ASSUME_NONNULL_END

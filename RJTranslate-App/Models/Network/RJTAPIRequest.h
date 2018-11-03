//
//  RJTAPIRequest.h
//  RJTranslate-App
//
//  Created by Даниил on 26/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RJTAPIRequestCompletionBlock)(NSData * _Nullable responseData, NSError * _Nullable error);


@interface RJTAPIRequest : NSURLRequest

/**
 Инициализирует основной запрос. Не должно вызываться снаружи класса.

 @param URL Адрес удаленного сервера.
 @return Возвращает экземпляр класса для дальнейшей работы.
 */
+ (__kindof RJTAPIRequest *)defaultRequestWithURL:(NSURL *)URL;


/**
 Инициализирует простой запрос.

 @param URL Адрес удаленного сервера.
 @param completion Блок, определяющий действие при завершении.
 @return Возвращает экземпляр класса для дальнейшей работы.
 */
+ (RJTAPIRequest *)requestWithURL:(NSURL *)URL completion:(RJTAPIRequestCompletionBlock)completion;

/**
  Блок, определяющий действие при завершении запроса.
 */
@property (copy, nonatomic, readonly, nullable) RJTAPIRequestCompletionBlock completion;

/**
 Сырые данные, полученные в результате запроса.
 */
@property (strong, nonatomic, readonly) NSMutableData *responseData;

@end

NS_ASSUME_NONNULL_END

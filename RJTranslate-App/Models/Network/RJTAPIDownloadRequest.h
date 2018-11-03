//
//  RJTAPIDownloadRequest.h
//  RJTranslate-App
//
//  Created by Даниил on 27/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import "RJTAPIRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RJTAPIRequestProgressBlock)(double progress);
typedef void(^RJTAPIRequestDownloadCompletionBlock)(NSURL * _Nullable downloadedDataURL, NSError * _Nullable downloadError);


@interface RJTAPIDownloadRequest : RJTAPIRequest

/**
 Выполняет инициализацию запроса на загрузку.

 @param URL Адрес удаленного сервера.
 @param progressHandler Блок, обрабатывающий прогресс загрузки данных.
 @param completion Блок, определяющий действие при завершении загрузки.
 @return Возвращает экземпляр класса для дальнейшей работы.
 */
+ (RJTAPIDownloadRequest *)downloadRequestWithURL:(NSURL *)URL
                                  progressHandler:(RJTAPIRequestProgressBlock _Nullable)progressHandler
                                       completion:(RJTAPIRequestDownloadCompletionBlock)completion;

/**
 Блок, обрабатывающий прогресс загрузки данных.
 */
@property (copy, nonatomic, readonly, nullable) RJTAPIRequestProgressBlock progressHandler;

/**
 Блок, определяющий действие при завершении загрузки.
 */
@property (copy, nonatomic, readonly, nullable) RJTAPIRequestDownloadCompletionBlock downloadCompletion;

@end

NS_ASSUME_NONNULL_END

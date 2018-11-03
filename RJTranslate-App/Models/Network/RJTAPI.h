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

/**
 Инициализирует АПИ для выполнения запросов к удаленному серверу.

 @return Возвращает синглтон-экземпляр для дальнейшей работы.
 */
+ (instancetype)sharedAPI;

/**
 Определяет основной URL Апи.
 */
@property (strong, nonatomic, class, readonly) NSURL *apiURL;


/**
 Конфигурация сессии.
 */
@property (strong, nonatomic, readonly) NSURLSessionConfiguration *configuration;

/**
 Выполняет добавление запроса и стартует его.

 @param request Запрос для добавления в очередь.
 */
- (void)addRequest:(__kindof RJTAPIRequest *)request;

@end

NS_ASSUME_NONNULL_END

//
//  RJTTracker.h
//  RJTranslate-App
//
//  Created by Даниил on 09/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJTTracker : NSObject

/**
 Трекает событие изменения текста поиска.

 @param searchText Текст поиска.
 */
- (void)trackSearchEvent:(NSString *)searchText;

/**
 Трекает событие изменения включения локализации.

 @param name Имя локализации.
 */
- (void)trackSelectTranslationWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

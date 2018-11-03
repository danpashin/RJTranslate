//
//  RJTNavigationController.h
//  RJTranslate
//
//  Created by Даниил on 20/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJTNavigationController : UINavigationController

/**
 Выполняет показ или скрытие большого бара навигации.

 @param show YES - показывает. NO - скрывает.
 */
- (void)showNavigationLargeTitle:(BOOL)show;

@end

NS_ASSUME_NONNULL_END

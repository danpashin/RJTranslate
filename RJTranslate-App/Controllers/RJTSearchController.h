//
//  RJTSearchController.h
//  RJTranslate-App
//
//  Created by Даниил on 21/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RJTSearchController : UISearchController

/**
 Выполняет инициализацию контроллера поиска.

 @param delegate Устанавливает делегат для объекта.
 @param searchResultsUpdater Устанавливает делегат обновления поиска для объекта.
 @return Возвращает экземпляр класса для дальнейшей работы с контроллером.
 */
- (instancetype)initWithDelegate:(id <UISearchControllerDelegate>)delegate
            searchResultsUpdater:(id <UISearchResultsUpdating>)searchResultsUpdater;

/**
 Определяет, должен ли затемняться фон при начале поиска. По умолчанию, YES.
 */
@property (assign, nonatomic) BOOL dimBackground;

/**
 Возвращает текст поиска, который набирается пользователем.
 */
@property (copy, nonatomic, readonly) NSString *searchText;

/**
 Определет, выполняется ли поиск в данный момент.
 */
@property (assign, nonatomic, readonly) BOOL performingSearch;


- (instancetype)initWithSearchResultsController:(nullable UIViewController *)searchResultsController NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END

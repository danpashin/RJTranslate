//
//  RJTAppCollectionView.h
//  RJTranslate-App
//
//  Created by Даниил on 21/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RJTApplicationModel, RJTSearchController, RJTCollectionViewUpdateCell;

NS_ASSUME_NONNULL_BEGIN

@class RJTAppCollectionView;
@protocol RJTAppCollectionViewDelegate <NSObject>

- (void)collectionViewRequestedDownloadingTranslations:(RJTAppCollectionView *)collectionView;
- (void)collectionView:(RJTAppCollectionView *)collectionView didUpdateModel:(RJTApplicationModel *)appModel;

@optional
- (void)collectionView:(RJTAppCollectionView *)collectionView didLoadUpdateCell:(RJTCollectionViewUpdateCell *)updateCell;

@end



@interface RJTAppCollectionView : UICollectionView

/**
 Содержит модели приложений.
 */
@property (strong, nonatomic, nullable) NSArray <RJTApplicationModel *> *appModels;

/**
 Устанавливает контроллер поиска. Нужен для определения показа фонового вида.
 */
@property (weak, nonatomic, nullable) RJTSearchController *searchController;

/**
 Устанавливает кастомный делегат для объекта.
 */
@property (weak, nonatomic) id <RJTAppCollectionViewDelegate> customDelegate;


/**
 Выполняет анимированную перезагрузку ячеек коллекции.
 */
- (void)reload;

- (void)showUpdateCell:(BOOL)shouldShow;

- (void)reloadData NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

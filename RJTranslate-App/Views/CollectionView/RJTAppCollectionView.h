//
//  RJTAppCollectionView.h
//  RJTranslate-App
//
//  Created by Даниил on 21/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJTEmptyViewType.h"
@class RJTApplicationModel, RJTSearchController, RJTCollectionViewUpdateCell;
@class RJTCollectionViewModel;

NS_ASSUME_NONNULL_BEGIN

@class RJTAppCollectionView;
@protocol RJTAppCollectionViewDelegateProtocol <NSObject>

- (void)collectionViewRequestedDownloadingTranslations:(RJTAppCollectionView *)collectionView;
- (void)collectionView:(RJTAppCollectionView *)collectionView didUpdateModel:(RJTApplicationModel *)appModel;

@optional
- (void)collectionView:(RJTAppCollectionView *)collectionView didLoadUpdateCell:(RJTCollectionViewUpdateCell *)updateCell;

@end



@interface RJTAppCollectionView : UICollectionView

/**
 Устанавливает кастомный делегат для объекта.
 */
@property (weak, nonatomic) id <RJTAppCollectionViewDelegateProtocol> customDelegate;

/**
 Модель, используемая для коллекции.
 */
@property (strong, nonatomic, readonly) RJTCollectionViewModel *model;


/**
 Выполняет анимированную перезагрузку ячеек коллекции.
 */
- (void)reload;

/**
 Показывает/скрывает ячейку с обновлением.

 @param shouldShow YES - показывает, NO - скрывает.
 */
- (void)showUpdateCell:(BOOL)shouldShow;

- (void)updateLayoutToSize:(CGSize)size;

- (void)updateEmptyViewToType:(RJTEmptyViewType)type;

- (void)updateEmptyViewToType:(RJTEmptyViewType)type animated:(BOOL)animated;

- (void)reloadData NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

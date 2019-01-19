//
//  RJTAppCollectionView.h
//  RJTranslate-App
//
//  Created by Даниил on 21/10/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmptyViewType.h"

@class RJTApplicationModel, RJTSearchController, CollectionUpdateCell;
@class RJTCollectionViewModel;

NS_ASSUME_NONNULL_BEGIN

@class RJTAppCollectionView;
@protocol RJTAppCollectionViewDelegateProtocol <NSObject>

- (void)collectionViewRequestedDownloadingTranslations:(RJTAppCollectionView *)collectionView;
- (void)collectionView:(RJTAppCollectionView *)collectionView didUpdateModel:(RJTApplicationModel *)appModel;

@optional
- (void)collectionView:(RJTAppCollectionView *)collectionView didLoadUpdateCell:(CollectionUpdateCell *)updateCell;

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

- (void)updateEmptyViewToType:(EmptyViewType)type NS_SWIFT_NAME(updateEmptyView(to:));

- (void)updateEmptyViewToType:(EmptyViewType)type animated:(BOOL)animated NS_SWIFT_NAME(updateEmptyView(to:animated:));

- (void)reloadData NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

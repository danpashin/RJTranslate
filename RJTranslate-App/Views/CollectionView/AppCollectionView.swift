//
//  AppCollectionView.swift
//  RJTranslate-App
//
//  Created by Даниил on 24/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

@objc protocol AppCollectionViewDelegateProtocol {

    /// Вызывается, когда пользователь нажимает на кнопку загрузки переводов.
    ///
    /// - Parameter collectionView: Экземпляр коллекции.
    func collectionViewRequestedDownloadingTranslations(_ collectionView: AppCollectionView)
    
    /// Вызывается, когда пользователь тапнул по ячейке с переводом.
    ///
    /// - Parameters:
    ///   - collectionView: Экземпляр коллекции.
    ///   - model: Экземпляр модели перевода в ячейке.
    func collectionView(_ collectionView: AppCollectionView, didUpdateModel model: RJTApplicationModel)
    
    /// Вызывается, когда ячейка с новым обновлением переводом появилась на экране.
    ///
    /// - Parameters:
    ///   - collectionView: Экземпляр коллекции.
    ///   - didLoadUpdateCell: Экземпляр ячейки с переводом.
    @objc optional func collectionView(_ collectionView: AppCollectionView, didLoadUpdateCell: CollectionUpdateCell)
}


class AppCollectionView : UICollectionView {
    
    /// Устанавливает кастомный делегат для объекта.
    weak public var customDelegate: AppCollectionViewDelegateProtocol?
    
    /// Модель, используемая для коллекции.
    public var model: AppCollectionModel?
    
    
    public var layout: AppCollectionLayout? {
        return self.collectionViewLayout as? AppCollectionLayout
    }
    
    private var delegateObject: AppCollectionDelegate?
    private var emptyDataSourceObject: AppCollectionEmptySource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateLayoutToSize(UIScreen.main.bounds.size)
        self.backgroundColor = ColorScheme.default.background
        
        self.alwaysBounceVertical = true
        self.allowsMultipleSelection = true
        
        self.delegateObject = AppCollectionDelegate(collectionView: self)
        self.emptyDataSourceObject = AppCollectionEmptySource(collectionView: self)
    }
    
    /// Выполняет анимированную перезагрузку ячеек коллекции.
    public func reload() {
        DispatchQueue.main.async {
            if self.numberOfSections > 0 {
                self.reloadSections(NSIndexSet(indexesIn: NSRange(location: 0, length: self.numberOfSections)) as IndexSet)
            }
            self.reloadEmptyDataSet()
        }
    }

    
    /// Показывает/скрывает ячейку с обновлением.
    ///
    /// - Parameter show: YES - показывает, NO - скрывает.
    public func showUpdateCell(_ show: Bool) {
        if (self.delegateObject?.showUpdateHeader != show) {
            self.delegateObject?.showUpdateHeader = show;
            self.reload()
        }
    }
    
    public func updateLayoutToSize(_ size: CGSize) {
        self.layout?.invalidateLayout()
    }
    
    public func updateEmptyView(to type: EmptyViewType, animated: Bool = false) {
        if self.emptyDataSourceObject?.type == type {
            return
        }
        
        DispatchQueue.main.async {
            self.emptyDataSourceObject?.type = type
            
            if !animated {
                self.reloadEmptyDataSet()
            } else {
                UIView.transition(with: self, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                    self.reloadEmptyDataSet()
                })
            }
        }
    }
    
    
    @available(*, unavailable)
    override func reloadData() {
        super.reloadData()
    }
    
}

//
//  AppCollectionView.swift
//  RJTranslate-App
//
//  Created by Даниил on 24/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

@objc protocol AppCollectionViewDelegateProtocol: NSObjectProtocol {

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


@objc class AppCollectionView : UICollectionView {
    
    /// Контроллер поиска. Нужен для определения показа фонового вида.
    @objc weak public var searchController: SearchController?
    
    /// Устанавливает кастомный делегат для объекта.
    @objc weak public var customDelegate: AppCollectionViewDelegateProtocol?
    
    /// Модель, используемая для коллекции.
    @objc public var model: RJTCollectionViewModel?
    
    
    @objc public var layout: RJTCollectionViewLayout? {
        return (self.collectionViewLayout as! RJTCollectionViewLayout)
    }
    
    private var delegateObject: RJTAppCollectionViewDelegate?
    private var emptyDataSourceObject: RJTCollectionViewEmptyDataSource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateLayoutToSize(UIScreen.main.bounds.size)
        
        self.alwaysBounceVertical = true
        self.allowsMultipleSelection = true
        
        self.delegateObject = RJTAppCollectionViewDelegate.init(collectionView: self)
        self.emptyDataSourceObject = RJTCollectionViewEmptyDataSource.init(collectionView: self)
    }
    
    /// Выполняет анимированную перезагрузку ячеек коллекции.
    @objc public func reload() {
        DispatchQueue.main.async {
            self.reloadSections(IndexSet(0...3))
            self.reloadEmptyDataSet()
        }
    }
    
    /// Показывает/скрывает ячейку с обновлением.
    ///
    /// - Parameter show: YES - показывает, NO - скрывает.
    @objc public func showUpdateCell(_ show: Bool) {
        if (self.delegateObject?.showUpdateHeader != show) {
            self.delegateObject?.showUpdateHeader = show;
            self.reload()
        }
    }
    
    @objc public func updateLayoutToSize(_ size: CGSize) {
        self.layout?.itemSize = self.layout?.itemSize(fromCollectionFrame: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)) ?? CGSize.zero
        self.layout?.invalidateLayout()
    }
    
    @available(*, unavailable)
    override func reloadData() {
        super.reloadData()
    }
    
}

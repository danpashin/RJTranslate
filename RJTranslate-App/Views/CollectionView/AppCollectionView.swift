//
//  AppCollectionView.swift
//  RJTranslate-App
//
//  Created by Даниил on 24/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

@objc protocol AppCollectionViewDelegate: NSObjectProtocol {

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
    
    /// Контроллер поиска. Нужен для определения показа фонового вида.
    weak public var searchController: SearchController?
    
    /// Устанавливает кастомный делегат для объекта.
    weak public var customDelegate: AppCollectionViewDelegate?
    
    /// Модель, используемая для коллекции.
    public private(set) var model: RJTCollectionViewModel?
    
    
//    internal var collectionViewLayout: UICollectionViewLayout {
//
//    }
    
    private var delegateObject: RJTAppCollectionViewDelegate?
    private var emptyDataSourceObject: RJTCollectionViewEmptyDataSource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateLayoutToSize(UIScreen.main.bounds.size)
        
        self.alwaysBounceVertical = true
        self.allowsMultipleSelection = true
        
//        self.delegateObject = RJTAppCollectionViewDelegate()
    }
    
    /// Выполняет анимированную перезагрузку ячеек коллекции.
    public func reload() {
        DispatchQueue.main.async {
            
        }
    }
    
    /// Показывает/скрывает ячейку с обновлением.
    ///
    /// - Parameter show: YES - показывает, NO - скрывает.
    public func showUpdateCell(_ show: Bool) {
        
    }
    
    public func updateLayoutToSize(_ size: CGSize) {
        
    }
    
    @available(*, unavailable)
    override func reloadData() {
        fatalError()
    }
    
}

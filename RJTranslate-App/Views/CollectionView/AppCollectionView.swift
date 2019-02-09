//
//  AppCollectionView.swift
//  RJTranslate-App
//
//  Created by Даниил on 24/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

@objc  protocol AppCollectionViewDelegateProtocol {
    
    /// Вызывается, когда пользователь тапнул по ячейке с переводом.
    ///
    /// - Parameters:
    ///   - collectionView: Экземпляр коллекции.
    ///   - model: Экземпляр модели перевода в ячейке.
    func collectionView(_ collectionView: AppCollectionView, didUpdateModel model: TranslationModel)
}


class AppCollectionView: UICollectionView {
    
    /// Устанавливает кастомный делегат для объекта.
    weak  var customDelegate: AppCollectionViewDelegateProtocol?
    
    /// Модель, используемая для коллекции.
    var model: AppCollectionModel!
    
    
    var layout: AppCollectionLayout {
        return self.collectionViewLayout as! AppCollectionLayout
    }
    
    private var delegateObject: AppCollectionDelegate!
    private var emptyDataSourceObject: AppCollectionEmptySource!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.commonInit()
    }
    
    private func commonInit() {
        self.model = AppCollectionModel(collectionView: self)
        self.delegateObject = AppCollectionDelegate(collectionView: self, model: self.model)
        self.emptyDataSourceObject = AppCollectionEmptySource(collectionView: self)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layout.invalidateLayout()
        self.backgroundColor = ColorScheme.default.background
        
        self.alwaysBounceVertical = true
        self.allowsMultipleSelection = true
    }
    
    /// Выполняет анимированную перезагрузку ячеек коллекции.
    func reload() {
        // TODO: Добавить анимацию перемещения.
        DispatchQueue.main.async {
            var pathsToDelete = [IndexPath]()
            var pathsToInsert = [IndexPath]()
            var pathsToReload = [IndexPath]()
            
            for section in 0..<self.numberOfSections {
                let currentSourceCount = self.model?.currentDataSource.numberOfModelsFor(section: section) ?? 0
                
                let sectionItems = self.numberOfItems(inSection: section)
                if sectionItems > currentSourceCount {
                    for row in currentSourceCount ..< sectionItems {
                        pathsToDelete.append(IndexPath(row: row, section: section))
                    }
                } else if sectionItems < currentSourceCount {
                    for row in sectionItems ..< currentSourceCount {
                        pathsToInsert.append(IndexPath(row: row, section: section))
                    }
                }
                
                for row in 0 ..< currentSourceCount {
                    pathsToReload.append(IndexPath(item: row, section: section))
                }
            }
            
            pathsToReload = pathsToReload.filter { !pathsToDelete.contains($0) && !pathsToInsert.contains($0) }
            
            
            self.performBatchUpdates({
                self.deleteItems(at: pathsToDelete)
                self.insertItems(at: pathsToInsert)
                self.reloadItems(at: pathsToReload)
                self.reloadEmptyDataSet()
            })
        }
    }
    
    func updateEmptyView(to type: EmptyViewType, animated: Bool = false) {
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

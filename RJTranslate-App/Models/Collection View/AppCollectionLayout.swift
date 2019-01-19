//
//  AppCollectionLayout.swift
//  RJTranslate-App
//
//  Created by Даниил on 13/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class AppCollectionLayout : UICollectionViewFlowLayout, AppCollectionDataSourceChange {
    
    private var oldDataSource: AppCollectionDataSource?
    private weak var currentDataSource: AppCollectionDataSource?
    
    override init() {
        super.init()
        self.commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 20.0, right: 0.0)
    }
    
    override public func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        self.oldDataSource = nil
    }
    
    public func dataSourceChanged(from oldDataSource: AppCollectionDataSource?, to newDatasource: AppCollectionDataSource?) {
        self.oldDataSource = oldDataSource
        self.currentDataSource = newDatasource
    }
    
    
    //  MARK: -
    
    override public func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        
        var oldItemsCount = 0
        if itemIndexPath.section == 1 {
            oldItemsCount = self.oldDataSource?.installed.count ?? 0
        } else if itemIndexPath.section == 2 {
            oldItemsCount = self.oldDataSource?.uninstalled.count ?? 0
        }
        
        if self.oldDataSource != nil && itemIndexPath.item > oldItemsCount - 1 {
            attributes?.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }
        
        return attributes;
    }
    
    override public func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        
        var newItemsCount = 0
        if itemIndexPath.section == 1 {
            newItemsCount = self.oldDataSource?.installed.count ?? 0
        } else if itemIndexPath.section == 2 {
            newItemsCount = self.oldDataSource?.uninstalled.count ?? 0
        }
        
        if itemIndexPath.item > newItemsCount - 1 {
            attributes?.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }
        
        return attributes;
    }
}

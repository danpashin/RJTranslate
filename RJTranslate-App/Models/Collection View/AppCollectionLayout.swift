//
//  AppCollectionLayout.swift
//  RJTranslate-App
//
//  Created by Даниил on 13/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class AppCollectionLayout: UICollectionViewFlowLayout {
    
    private var itemsToAnimate = [IndexPath]()
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        for item in updateItems {
            switch item.updateAction {
            case .insert:
                self.itemsToAnimate.append(item.indexPathAfterUpdate!)
            case .delete:
                self.itemsToAnimate.append(item.indexPathBeforeUpdate!)
                
            default: break
            }
        }
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
            
            if self.itemsToAnimate.contains(itemIndexPath) {
                self.itemsToAnimate.remove(at: self.itemsToAnimate.firstIndex(of: itemIndexPath)!)
                attributes?.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            }
            
            return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
            
            if self.itemsToAnimate.contains(itemIndexPath) {
                self.itemsToAnimate.remove(at: self.itemsToAnimate.firstIndex(of: itemIndexPath)!)
                attributes?.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            }
            
            return attributes
    }
}

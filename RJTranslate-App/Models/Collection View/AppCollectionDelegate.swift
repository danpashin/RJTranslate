//
//  AppCollectionDelegate.swift
//  RJTranslate-App
//
//  Created by Даниил on 17/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

@objc class AppCollectionDelegate : NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @objc public private(set) var collectionView: RJTAppCollectionView?
    
    @objc public var showUpdateHeader: Bool = false
    
//    @objc public private(set) updateHeader: CollectionUpdateCell
    
    private var collectionModel: RJTCollectionViewModel
    
    @objc public init(collectionView: RJTAppCollectionView) {
        self.collectionView = collectionView
        self.collectionModel = collectionView.model
        
//        super.init()
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        collectionView.register(CollectionHeaderLabel.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "")
        
    }
    
    
    // MARK: -
    // MARK: UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            
        }
        
        let model = self.collectionView?.model
        switch section {
        case 0:
            return self.showUpdateHeader ? 1 : 0
        case 1:
            return model?.currentDataSource.installed.count
        default:
            return 0
        }
        
        
    }
}

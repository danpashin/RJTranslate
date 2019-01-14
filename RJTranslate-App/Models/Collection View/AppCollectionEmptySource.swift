//
//  AppCollectionEmptySource.swift
//  RJTranslate-App
//
//  Created by Даниил on 13/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

@objc class AppCollectionEmptySource: NSObject, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @objc public private(set) weak var collectionView: RJTAppCollectionView?
    
    @objc public var type: EmptyViewType = .loading
    
    
    @objc public init(collectionView: RJTAppCollectionView) {
        super.init()
        
        self.collectionView = collectionView
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMemoryWarning), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    @objc public func didReceiveMemoryWarning() {
        
    }
}

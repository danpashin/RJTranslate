//
//  TranslateMainController.swift
//  RJTranslate-App
//
//  Created by Даниил on 02/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

@objc class TranslateMainController: UIViewController, SearchControllerDelegate, RJTAppCollectionViewDelegate, RJTDatabaseUpdaterDelegate  {
    
    private var databaseUpdater: RJTDatabaseUpdater?
    private var collectionViewModel: RJTCollectionViewModel?
    
    private weak var hud: RJTHud?
    private var searchController: SearchController?
    @objc private weak var collectionView: RJTAppCollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("available_translations", comment: "")
        
        self.searchController = SearchController(delegate: self)
        self.collectionView.searchController = self.searchController
    }
}

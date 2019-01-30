//
//  TranslateMainController.swift
//  RJTranslate-App
//
//  Created by Даниил on 02/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

public class TranslateMainController: SimpleViewController, SearchControllerDelegate, AppCollectionViewDelegateProtocol  {
    
    private weak var hud: RJTHud?
    private var searchController: SearchControllerRequired!
    
    @IBOutlet
    private var collectionView: AppCollectionView! {
        didSet {
            self.collectionView.customDelegate = self
            self.collectionView.model.loadDatabaseModels()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Translations.Tab.Installed.Title", comment: "")
        
        if #available(iOS 11.0, *) {
            self.searchController = ModernSearchController(delegate: self)
            self.navigationItem.searchController = self.searchController as! ModernSearchController
        } else {
            let obsoleteSearch = ObsoleteSearchController(delegate: self)
            self.searchController = obsoleteSearch
            
            self.navigationItem.titleView = obsoleteSearch.createSearchBarForView(self.navigationController!.navigationBar)
        }
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.updateLayoutToSize(size)
    }
    
    
    // MARK: -
    // MARK: SearchControllerRequired
    
    public func willPresentSearchController(_ searchController: SearchControllerRequired) {
        self.collectionView.model.beginSearch()
    }
    
    public func searchController(_ searchController: SearchControllerRequired, didUpdateSearchText searchText: String) {
        self.collectionView.model.performSearch(text: searchText)
    }
    
    public func willDismissSearchController(_ searchController: SearchControllerRequired) {
        self.collectionView.model.endSearch()
    }
    
    
    // MARK: -
    // MARK: RJTAppCollectionViewDelegate
    
    public func collectionView(_ collectionView: AppCollectionView, didUpdateModel appModel: RJTApplicationModel) {
        self.collectionView.model.updateModel(appModel)
    }
    
    
    public func reloadTranslations() {
        self.collectionView.model.loadDatabaseModels()
    }

}

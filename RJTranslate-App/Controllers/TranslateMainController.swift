//
//  TranslateMainController.swift
//  RJTranslate-App
//
//  Created by Даниил on 02/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

class TranslateMainController: SimpleController, SearchControllerDelegate, AppCollectionViewDelegateProtocol, DatabaseUpdaterDelegate  {
    
    private var databaseUpdater: DatabaseUpdater!
    
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
        self.databaseUpdater = DatabaseUpdater(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Translations.Installed.Title", comment: "")
        
        if #available(iOS 11.0, *) {
            self.searchController = ModernSearchController(delegate: self)
            self.navigationItem.searchController = self.searchController as! ModernSearchController
        } else {
            let obsoleteSearch = ObsoleteSearchController(delegate: self)
            self.searchController = obsoleteSearch
            
            self.navigationItem.titleView = obsoleteSearch.createSearchBarForView(self.navigationController!.navigationBar)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.once(token: "ru.danpashin.rjtranslate.updates.once") {
            self.databaseUpdater.checkTranslationsVersion({ (updateModel: TranslationsUpdate?, error: NSError?) in
                if error == nil && updateModel?.canUpdate ?? false {
                    self.collectionView?.showUpdateCell(true)
                }
            })
        }
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.collectionView.updateLayoutToSize(size)
    }
    
    @objc private func actionUpdateDatabase() {
        let hud = RJTHud.show()
        hud.text = NSLocalizedString("please_wait", comment: "")
        hud.detailText = NSLocalizedString("downloating_localization...", comment: "")
        self.hud = hud
        
        self.databaseUpdater.performUpdate()
    }
    
    
    // MARK: -
    // MARK: SearchControllerRequired
    
    public func willPresentSearchController(_ searchController: SearchControllerRequired) {
        self.collectionView.model.beginSearch()
    }
    
    public func searchController(_ searchController: SearchControllerRequired, didUpdateSearchText searchText: String) {
        self.collectionView.showUpdateCell(false)
        self.collectionView.model.performSearch(text: searchText)
    }
    
    public func willDismissSearchController(_ searchController: SearchControllerRequired) {
        self.collectionView.model.endSearch()
    }
    
    
    // MARK: -
    // MARK: RJTAppCollectionViewDelegate
    
    public func collectionViewRequestedDownloadingTranslations(_ collectionView: AppCollectionView) {
        self.actionUpdateDatabase()
    }
    
    public func collectionView(_ collectionView: AppCollectionView, didUpdateModel appModel: RJTApplicationModel) {
        self.collectionView.model.updateModel(appModel)
    }
    
    public func collectionView(_ collectionView: AppCollectionView, didLoadUpdateCell updateCell: CollectionUpdateCell) {
        updateCell.textLabel.text = NSLocalizedString("translations_update_is_available", comment: "")
        updateCell.detailedTextLabel.text = NSLocalizedString("tap_to_download", comment: "")
        updateCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionUpdateDatabase)))
    }
    
    
    // MARK: -
    // MARK: DatabaseUpdaterDelegate
    
    public func databaseUpdaterDidStartUpdatingDatabase(_ databaseUpdater: DatabaseUpdater) {
        self.hud?.progress = 0.75
        self.hud?.detailText = NSLocalizedString("updating_database...", comment: "")
    }
    
    public func databaseUpdater(_ databaseUpdater: DatabaseUpdater, finishedUpdate models: [RJTApplicationModel]) {
        self.hud?.hide(animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.collectionView.showUpdateCell(false)
            
            self.collectionView.model.loadDatabaseModels()
        })
    }
    
    public func databaseUpdater(_ updater: DatabaseUpdater, failed error: Error) {
        self.hud?.style = .textOnly
        self.hud?.text = NSLocalizedString("failed_to_update", comment: "")
        self.hud?.detailText = error.localizedDescription
        self.hud?.hide(afterDelay: 2.0)
    }
    
    public func databaseUpdater(_ databaseUpdater: DatabaseUpdater, updateProgress progress: Double) {
        self.hud?.setProgress(CGFloat(progress), animated: true)
    }



}

//
//  TranslationDetailController.swift
//  RJTranslate-App
//
//  Created by Даниил on 24/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class TranslationDetailController: SimpleViewController, TranslationDetailViewDelegate {
    
    
    private(set) var translationModel: TranslationModel? {
        didSet {
            self.performUIUpdate()
        }
    }
    private var translationSummary: API.TranslationSummary?
    
    private var translationView: TranslationDetailView?
    
    
    
    init(translation: TranslationModel) {
        defer {
            self.translationModel = translation
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(translationSummary: API.TranslationSummary) {
        self.translationSummary = translationSummary
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorScheme.default.backgroundWhite
        
        let navigationBar = UIApplication.applicationDelegate.currentNavigationController.navigationBar
        navigationBar.hideShadow(animated: true)
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
        
        self.setupViews()
        self.updateSummaryIfNeeded()
    }
    
    private func setupViews() {
        self.translationView = TranslationDetailView()
        self.translationView?.delegate = self
        self.view.addSubview(self.translationView!)
        
        self.translationView!.translatesAutoresizingMaskIntoConstraints = false
        
        var viewTopAnchor: NSLayoutYAxisAnchor!
        var viewBottomAnchor: NSLayoutYAxisAnchor!
        
        if #available(iOS 11.0, *) {
            viewTopAnchor = self.view.safeAreaLayoutGuide.topAnchor
            viewBottomAnchor = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            viewTopAnchor = self.topLayoutGuide.bottomAnchor
            viewBottomAnchor = self.bottomLayoutGuide.topAnchor
        }
        
        
        NSLayoutConstraint.activate([
            self.translationView!.topAnchor.constraint(equalTo: viewTopAnchor),
            self.translationView!.bottomAnchor.constraint(equalTo: viewBottomAnchor),
            self.translationView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.translationView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            ])
    }
    
    private func updateSummaryIfNeeded() {
        if self.translationModel == nil && self.translationSummary != nil {
            let activityView = UIActivityIndicatorView(style: .gray)
            activityView.center = self.view.center
            activityView.startAnimating()
            self.view.addSubview(activityView)
            
            TranslationModel.loadFullModel(from: self.translationSummary!) {
                (model: TranslationModel?, error: NSError?) in
                DispatchQueue.main.async {
                    activityView.stopAnimating()
                    activityView.removeFromSuperview()
                    
                    self.translationModel = model
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabbar = UIApplication.applicationDelegate.tabbarController.tabBar
        tabbar.hideShadow(animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let tabbar = UIApplication.applicationDelegate.tabbarController.tabBar
        tabbar.showShadow(animated: animated)
    }
    
    override var controllerShouldPop: Bool {
        let navigationBar = UIApplication.applicationDelegate.currentNavigationController.navigationBar
        navigationBar.showShadow(animated: true)
        
        return true
    }
    
    private func performUIUpdate() {
        guard let translationModel = self.translationModel else { return }
        guard let translationView = self.translationView else { return }
        
        translationView.installButton.isHidden = false
        translationView.titleLabel.text = translationModel.displayedName
        
        let updateStringDate = DateFormatter.localizedString(from: translationModel.remoteUpdateDate, 
                                                             dateStyle: .medium, timeStyle: .none)
        let subtitleText = String(format: NSLocalizedString("Translation.Detail.Updated", comment: ""), updateStringDate)
        translationView.subtitleLabel.text = subtitleText
        
        translationModel.loadIcon(big: true, completion: { (icon: UIImage?) in
            DispatchQueue.main.async {
                UIView.transition(with: translationView, duration: 0.1, options: .transitionCrossDissolve, animations: { 
                    self.translationView?.iconView.image = icon
                })
            }
        })
    }
    
    
    // MARK: -
    // MARK: TranslationDetailViewDelegate
    
    func detailViewRequestedDownloadingTranslation(_ detailView: TranslationDetailView) {
        guard let model = self.translationModel else { return }
        let hud = RJTHud.show()
        
        let database = UIApplication.applicationDelegate.defaultDatabase!
        database.addAppModels([model]) {
            database.forceSaveContext()
            NotificationCenter.post(name: .translationCollectionLoadDatabase)
            
            hud.hide(afterDelay: 1.0)
        }
    }
}

//
//  TranslationDetailController.swift
//  RJTranslate-App
//
//  Created by Даниил on 24/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

public class TranslationDetailController: SimpleViewController, TranslationDetailViewDelegate {
    
    
    public private(set) var translationModel: RJTApplicationModel? {
        didSet {
            self.performUIUpdate()
        }
    }
    private var translationSummary: API.TranslationSummary?
    
    private var translationView: TranslationDetailView?
    
    
    
    public init(translation: RJTApplicationModel) {
        defer {
            self.translationModel = translation
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(translationSummary: API.TranslationSummary) {
        self.translationSummary = translationSummary
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let navigationBar = UIApplication.applicationDelegate.currentNavigationController.navigationBar
        navigationBar.hideShadow()
        
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
            
            RJTApplicationModel.loadFullModel(from: self.translationSummary!) {
                (model: RJTApplicationModel?, error: NSError?) in
                DispatchQueue.main.async {
                    activityView.stopAnimating()
                    activityView.removeFromSuperview()
                    
                    self.translationModel = model
                }
            }
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabbar = UIApplication.applicationDelegate.tabbarController.tabBar
        tabbar.hideShadow(animated: animated)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let tabbar = UIApplication.applicationDelegate.tabbarController.tabBar
        tabbar.showShadow(animated: animated)
    }
    
    override public var controllerShouldPop: Bool {
        let navigationBar = UIApplication.applicationDelegate.currentNavigationController.navigationBar
        navigationBar.showShadow()
        
        return true
    }
    
    private func performUIUpdate() {
        guard let translationModel = self.translationModel else { return }
        guard let translationView = self.translationView else { return }
         
        translationView.titleLabel.text = translationModel.displayedName
        
        let updateStringDate = DateFormatter.localizedString(from: translationModel.updateDate, 
                                                             dateStyle: .medium, timeStyle: .none)
        let subtitleText = String(format: NSLocalizedString("Translation.Detail.Updated", comment: ""), updateStringDate)
        translationView.subtitleLabel.text = subtitleText
        
        translationModel.loadIcon(big: true, completion: { (icon: UIImage?) in
            DispatchQueue.main.async {
                UIView.transition(with: translationView, duration: 0.1, options: .transitionCrossDissolve, animations: { 
                    self.translationView?.iconView.image = icon
                })
            }
            
//            if let averageColor = icon?.averageColor {
//                var red: CGFloat = 0.0
//                var green: CGFloat = 0.0
//                var blue: CGFloat = 0.0
//                averageColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
//                
//                if red < 0.8 && green < 0.8 && blue < 0.8 {
//                    self.translationView?.iconView.layer.shadowColor = averageColor.withAlphaComponent(0.15).cgColor
//                }
//            }
        })
    }
    
    
    // MARK: -
    // MARK: TranslationDetailViewDelegate
    
    public func detailViewRequestedDownloadingTranslation(_ detailView: TranslationDetailView) {
        let database = UIApplication.applicationDelegate.defaultDatabase!
        database.addAppModels([self.translationModel!]) {
            database.forceSaveContext()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { 
                let mainController = UIApplication.applicationDelegate.tabbarController.mainController
                mainController.reloadTranslations()
            })
        }
    }
}

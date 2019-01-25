//
//  TranslationDetailController.swift
//  RJTranslate-App
//
//  Created by Даниил on 24/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

public class TranslationDetailController: UIViewController {
    
    public private(set) var translationModel: RJTApplicationModel? {
        didSet {
            DispatchQueue.main.async {
                self.performUIUpdate()
            }
        }
    }
    private var translationSummary: API.TranslationSummary?
    
    private let titleLabel = UILabel()
    private let iconView = UIImageView()
    private let installButton = UIButton()
    
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
        
        self.view.backgroundColor = ColorScheme.default.background
//        self.view.backgroundColor = UIColor.white
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
        
        self.view.addSubview(self.iconView)
        self.view.addSubview(self.titleLabel)
        
        
        self.iconView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.iconView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20.0),
            self.iconView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.iconView.widthAnchor.constraint(equalToConstant: 72.0),
            self.iconView.heightAnchor.constraint(equalToConstant: 72.0),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.iconView.topAnchor, constant: 8.0),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0.0),
            self.titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0.0)
            ])
        
        if self.translationModel == nil && self.translationSummary != nil {
            RJTApplicationModel.loadFullModel(from: self.translationSummary!) {
                (model: RJTApplicationModel?, error: NSError?) in
                self.translationModel = model
            }
        }
    }
    
    private func performUIUpdate() {
        guard let translationModel = self.translationModel else { return }
        
        self.titleLabel.text = translationModel.displayedName
        
        translationModel.loadIcon { (icon: UIImage?) in
            DispatchQueue.main.async {
                self.iconView.image = icon
            }
        }
    }
}

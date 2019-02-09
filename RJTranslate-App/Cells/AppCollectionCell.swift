//
//  AppCollectionCell.swift
//  RJTranslate-App
//
//  Created by Даниил on 01/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation
import UIKit

class AppCollectionCell: TouchResponsiveCollectionCell {
    
    static let defaultHeight: CGFloat = 76.0
    
    var model: TranslationModel? {
        didSet {
            updateForNewModel()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        }
    }
    
    private var iconView = UIImageView()
    private var nameLabel = UILabel()
    private var identifierLabel = UILabel()
    private var tickView = TickView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = ColorScheme.default.collectionCellBackground
        
        self.nameLabel.textColor = ColorScheme.default.titleLabel
        self.nameLabel.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .medium)
        self.addSubview(self.nameLabel)
        
        self.identifierLabel.textColor = ColorScheme.default.subtitleLabel
        self.identifierLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .regular)
        self.addSubview(self.identifierLabel)
        
        self.layer.cornerRadius = 10.0
        self.iconView.layer.masksToBounds = true
        self.iconView.layer.cornerRadius = 11.0
        self.iconView.tintColor = ColorScheme.default.subtitleLabel
        self.addSubview(self.iconView)
        
        self.addSubview(self.tickView)
        self.updateSelection(false, animated: false)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.05
        self.layer.masksToBounds = false
        
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.iconView.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.identifierLabel.translatesAutoresizingMaskIntoConstraints = false
        self.tickView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12.0),
            self.iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.iconView.widthAnchor.constraint(equalToConstant: 50.0),
            self.iconView.heightAnchor.constraint(equalToConstant: 50.0),
            
            self.nameLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.iconView.trailingAnchor, constant: 12.0),
            self.nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0.0),
            self.nameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0.0),
            
            self.identifierLabel.topAnchor.constraint(equalTo: self.centerYAnchor),
            self.identifierLabel.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor),
            self.identifierLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0.0),
            self.identifierLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0.0),
            
            self.tickView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.tickView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0),
            self.tickView.widthAnchor.constraint(equalToConstant: 40.0),
            self.tickView.heightAnchor.constraint(equalToConstant: 20.0)
            ])
    }
    
    func updateSelection(_ selected: Bool, animated: Bool) {
        self.tickView.setEnabled(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.model = nil
        self.updateSelection(false, animated: false)
    }
    
    private func updateForNewModel() {
        self.nameLabel.text = model?.displayedName
        
        if self.model?.bundleIdentifier?.count ?? 0 > 0 && model?.executableName?.count ?? 0 > 0 {
            self.identifierLabel.text = String(format: "%@ - %@", self.model?.executableName ?? "",
                                               self.model?.bundleIdentifier ?? "")
        } else if model?.bundleIdentifier?.count ?? 0 > 0 {
            self.identifierLabel.text = self.model?.bundleIdentifier
        } else {
            self.identifierLabel.text = model?.executableName
        }
        
        if self.model == nil {
            self.iconView.image = UIImage(named: "app_default_icon")
        } else {
            self.model?.loadIcon(completion: { (icon: UIImage?) in
                DispatchQueue.main.async {
                    UIView.transition(with: self.iconView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                        self.iconView.image = icon
                    })
                }
            })
        }
    }
}

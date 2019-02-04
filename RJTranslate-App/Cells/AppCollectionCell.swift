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
    
    @IBOutlet private weak var iconView: UIImageView?
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var identifierLabel: UILabel?
    @IBOutlet private weak var tickView: TickView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel?.textColor = ColorScheme.default.titleLabel
        
        self.layer.cornerRadius = 10.0
        self.iconView?.layer.masksToBounds = true
        self.iconView?.layer.cornerRadius = 11.0
        self.iconView?.tintColor = ColorScheme.default.subtitleLabel
        
        self.updateSelection(false, animated: false)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.05
        self.layer.masksToBounds = false
    }
    
    func updateSelection(_ selected: Bool, animated: Bool) {
        self.tickView?.setEnabled(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.model = nil
        self.updateSelection(false, animated: false)
    }
    
    private func updateForNewModel() {
        self.nameLabel?.text = model?.displayedName
        
        if self.model?.bundleIdentifier?.count ?? 0 > 0 && model?.executableName?.count ?? 0 > 0 {
            self.identifierLabel?.text = String(format: "%@ - %@", self.model?.executableName ?? "", self.model?.bundleIdentifier ?? "");
        } else if model?.bundleIdentifier?.count ?? 0 > 0 {
            self.identifierLabel?.text = self.model?.bundleIdentifier;
        } else {
            self.identifierLabel?.text = model?.executableName;
        }
        
        if self.model == nil {
            self.iconView?.image = UIImage(named: "app_default_icon")
        } else {
            self.model?.loadIcon(completion: { (icon: UIImage?) in
                DispatchQueue.main.async {
                    guard let iconView = self.iconView else { return }
                    UIView.transition(with: iconView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                        iconView.image = icon
                    })
                }
            })
        }
    }
}

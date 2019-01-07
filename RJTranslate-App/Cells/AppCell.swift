//
//  AppCell.swift
//  RJTranslate-App
//
//  Created by Даниил on 01/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation
import UIKit

@objc public class AppCell: TouchResponsiveCollectionCell {
    @objc public var model: RJTApplicationModel? {
        didSet {
            updateForNewModel()
        }
    }
    
    override public var bounds: CGRect {
        didSet {
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        }
    }
    
    @IBOutlet private weak var iconView: UIImageView?
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var identifierLabel: UILabel?
    @IBOutlet private weak var tickView: RJTTickView?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel?.textColor = RJTColors.textPrimaryColor
        
        self.layer.cornerRadius = 10.0
        self.iconView?.layer.masksToBounds = true
        self.iconView?.layer.cornerRadius = 11.0
        self.iconView?.tintColor = RJTColors.textDetailColor
        
        self.updateSelection(false, animated: false)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.05
        self.layer.masksToBounds = false
    }
    
    @objc public func updateSelection(_ selected: Bool, animated: Bool) {
        self.tickView?.setEnabled(selected, animated: animated)
    }
    
    public override func prepareForReuse() {
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
            self.iconView?.image = UIImage(named: "icon_template")
        } else {
            self.model?.icon?.load(completion: { icon in
                let iconImage: UIImage? = icon ?? UIImage(named: "icon_template")
                
                DispatchQueue.main.async {
                    guard let iconView = self.iconView else { return }
                    UIView.transition(with: iconView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                        iconView.image = iconImage
                    }, completion: nil)
                }
            })
        }
    }
}

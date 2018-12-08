//
//  AppCell.swift
//  RJTranslate-App
//
//  Created by Даниил on 01/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation
import UIKit

@objc(RJTAppCell) public class AppCell: UICollectionViewCell {
    @objc public var model: RJTApplicationModel? {
        didSet {
            updateForNewModel()
        }
    }
    
    @IBOutlet private weak var iconView: UIImageView?
    @IBOutlet private weak var nameLabel: UILabel?
    @IBOutlet private weak var identifierLabel: UILabel?
    @IBOutlet private weak var tickView: RJTTickView?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel?.textColor = RJTColors.textPrimaryColor
        
        self.layer.cornerRadius = 10.0
        iconView?.layer.masksToBounds = true
        iconView?.layer.cornerRadius = 11.0
        iconView?.tintColor = RJTColors.textDetailColor
        
        updateSelection(false, animated: false)
    }
    
    @objc public func updateSelection(_ selected: Bool, animated: Bool) {
        tickView?.setEnabled(selected, animated: animated)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        model = nil
        updateSelection(false, animated: false)
    }
    
    private func updateForNewModel() {
        self.nameLabel?.text = model?.displayedName
        
        if model?.bundleIdentifier?.count ?? 0 > 0 && model?.executableName?.count ?? 0 > 0 {
            identifierLabel?.text = String(format: "%@ - %@", model?.executableName ?? "", model?.bundleIdentifier ?? "");
        } else if model?.bundleIdentifier?.count ?? 0 > 0 {
            identifierLabel?.text = model?.bundleIdentifier;
        } else {
            identifierLabel?.text = model?.executableName;
        }
        
        if model == nil {
            iconView?.image = UIImage(named: "icon_template")
        } else {
            model?.icon?.load(completion: { icon in
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

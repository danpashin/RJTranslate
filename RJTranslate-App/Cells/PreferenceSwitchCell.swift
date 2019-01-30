//
//  SwitchCell.swift
//  RJTranslate-App
//
//  Created by Даниил on 28/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation
import UIKit

class PreferenceSwitchCell : UITableViewCell {
    
    private var switchView = UISwitch()
    
    private var preferenceModel: SwitchPreference! {
        didSet {
            DispatchQueue.global().async {
                let switchEnabled: Bool = (self.preferenceModel?.value as! NSNumber).boolValue
                
                DispatchQueue.main.async {
                    self.switchView.isOn = switchEnabled
                }
            }
        }
    }
    
    public init(model: SwitchPreference, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.switchView.addTarget(self, action: #selector(self.switchTrigerred), for: .valueChanged)
        self.switchView.onTintColor = ColorScheme.default.switchOnTint
        self.accessoryView = self.switchView
        
        defer {
            self.preferenceModel = model
        }
    }
    
    @objc private func switchTrigerred(_ switchView: UISwitch) {
        let enabled = NSNumber(booleanLiteral: switchView.isOn)
        self.preferenceModel.save(value: enabled)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported. Use init(model: reuseIdentifier:)")
    }
}

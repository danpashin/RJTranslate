//
//  SwitchCell.swift
//  RJTranslate-App
//
//  Created by Даниил on 28/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation
import UIKit

class PreferenceSwitchCell: PreferenceCell {
    
    private var switchView = UISwitch()
    
    override var model: SwitchPreference {
        return super.model as! SwitchPreference
    }
    
    init(model: Preference, reuseIdentifier: String?) {
        super.init(model: model, reuseIdentifier: reuseIdentifier)
        
        self.switchView.addTarget(self, action: #selector(self.switchTrigerred), for: .valueChanged)
        self.switchView.onTintColor = ColorScheme.default.switchOnTint
        self.accessoryView = self.switchView
        
        self.updateSwitchValue()
    }
    
    private func updateSwitchValue() {
        DispatchQueue.global().async {
            let switchEnabled: Bool = (self.model.value as! NSNumber).boolValue
            
            DispatchQueue.main.async {
                self.switchView.isOn = switchEnabled
            }
        }
    }
    
    @objc private func switchTrigerred(_ switchView: UISwitch) {
        self.model.save(value: switchView.isOn as NSNumber)
    }
}

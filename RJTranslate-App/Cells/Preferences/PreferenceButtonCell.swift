//
//  PreferenceButtonCell.swift
//  RJTranslate-App
//
//  Created by Даниил on 30/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class PreferenceButttonCell: PreferenceCell {
    
    override var model: ButtonPreference {
        return super.model as! ButtonPreference
    }
    
    init(model: Preference, reuseIdentifier: String?) {
        super.init(model: model, reuseIdentifier: reuseIdentifier)
        
        switch self.model.style {
        case .default:
            self.textLabel!.textColor = ColorScheme.default.buttonTitle
        case .destructive:
            self.textLabel!.textColor = ColorScheme.default.buttonDestructiveTitle
        }
    }
}

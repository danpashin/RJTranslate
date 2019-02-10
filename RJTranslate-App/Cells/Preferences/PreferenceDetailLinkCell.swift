//
//  PreferenceDetailLinkCell.swift
//  RJTranslate-App
//
//  Created by Даниил on 10/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class PreferenceDetailLinkCell: PreferenceCell {
    
    init(model: Preference, reuseIdentifier: String?) {
        super.init(model: model, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.textLabel?.textColor = ColorScheme.default.accentMain
    }
}

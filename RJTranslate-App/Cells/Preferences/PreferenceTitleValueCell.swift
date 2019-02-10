//
//  PreferenceTitleValueCell.swift
//  RJTranslate-App
//
//  Created by Даниил on 10/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class PreferenceTitleValueCell: PreferenceCell {
    
    override var model: TitleValuePreference {
        return super.model as! TitleValuePreference
    }
    
    init(model: Preference, reuseIdentifier: String?) {
        super.init(model: model, reuseIdentifier: reuseIdentifier, style: .value1)
        self.textLabel?.text = self.model.title
        self.detailTextLabel?.text = self.model.value
    }
}

//
//  PreferenceButtonCell.swift
//  RJTranslate-App
//
//  Created by Даниил on 30/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class PreferenceButttonCell: UITableViewCell {
    
    private(set) var model: ButtonPreference!
    
    init(model: ButtonPreference, reuseIdentifier: String?) {
        defer { self.model = model }
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        switch model.style {
        case .default:
            self.textLabel!.textColor = ColorScheme.default.buttonTitle
        case .destructive:
            self.textLabel!.textColor = ColorScheme.default.buttonDestructiveTitle
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

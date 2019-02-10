//
//  PreferencesMainController.swift
//  RJTranslate-App
//
//  Created by Даниил on 10/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class PreferencesMainController: PreferencesController {
    
    override class var modelClass: PreferencesTableModel.Type {
        return PreferencesMainModel.self
    }
    
    override func commonInit() {
        super.commonInit()
        
        self.title = NSLocalizedString("Settings.Title", comment: "")
        self.navigationController?.tabBarItem.title = self.title
    }
    
    override func didSetPreferenceValue(_ value: AnyHashable?, forKey key: String) {
        if key == "send_statistics" {
            let enabled: Bool = (value as? NSNumber)?.boolValue ?? true
            UIApplication.applicationDelegate.enableTracker(enabled)
        }
    }
}

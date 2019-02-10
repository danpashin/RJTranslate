//
//  PreferencesDebugController.swift
//  RJTranslate-App
//
//  Created by Даниил on 10/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

#if DEBUG
class PreferencesDebugController: PreferencesController {
    override class var modelClass: PreferencesTableModel.Type {
        return PreferencesDebugModel.self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
    }
}
#endif

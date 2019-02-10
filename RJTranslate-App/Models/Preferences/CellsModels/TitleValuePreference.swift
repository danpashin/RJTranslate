//
//  TitleValuePreference.swift
//  RJTranslate-App
//
//  Created by Даниил on 10/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class TitleValuePreference: Preference {
    
    override var category: Preference.Category {
        return .titleValue
    }
    
    private(set) var value: String?
    
    init(title: String?, value: String?) {
        self.value = value
        super.init(title: title)
    }
}

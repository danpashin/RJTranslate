//
//  Preference.swift
//  RJTranslate-App
//
//  Created by Даниил on 30/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

class Preference {
     enum Category {
        case text
        case `switch`
        case button
    }

    
    /// Тип настройки. По умолчанию - текст.
     var category: Preference.Category {
        return .text
    }
    
    /// Название настройки.
    private(set) var title: String?
    
     weak var prefsTableModel: PreferencesTableModel?
    
     init(title: String?) {
        self.title = title
    }
}

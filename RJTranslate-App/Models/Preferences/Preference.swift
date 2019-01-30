//
//  Preference.swift
//  RJTranslate-App
//
//  Created by Даниил on 30/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

class Preference {
    public enum Category {
        case text
        case `switch`
        case button
    }

    
    /// Тип настройки. По умолчанию - текст.
    public var category: Preference.Category {
        return .text
    }
    
    /// Название настройки.
    public private(set) var title: String?
    
    public weak var prefsTableModel: PreferencesTableModel?
    
    public init(title: String?) {
        self.title = title
    }
}

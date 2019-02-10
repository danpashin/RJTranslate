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
        
        case none
        
        /// Текст с переключателем
        case `switch`
        
        /// Кнопка с действием.
        case button
        
        /// Детальный контроллер
        case detailLink
        
        /// Текст с одписью на правой стороне.
        case titleValue
    }
    
    
    /// Тип настройки. По умолчанию - ничего.
    var category: Preference.Category {
        return .none
    }
    
    /// Название настройки.
    private(set) var title: String?
    
    weak var prefsTableModel: PreferencesTableModel?
    
    init(title: String?) {
        self.title = title
    }
}

//
//  ButtonPreference.swift
//  RJTranslate-App
//
//  Created by Даниил on 30/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class ButtonPreference: Preference {
    
    override var category: Preference.Category {
        return .button
    }
    
     enum Style {
        
        /// Стандартный стиль кнопки.
        case `default`
        
        /// Предупреждающий стиль кнопки.
        case destructive
    }
    
    
    
    /// Цель для кнопки при нажатии.
    private(set) var target: Any
    
    /// Селектор для вызова при нажатии.
    private(set) var action: Selector
    
    /// Стиль кнопки.
    private(set) var style: ButtonPreference.Style
    
     init(title: String?, target: Any, action: Selector, style: ButtonPreference.Style = ButtonPreference.Style.default) {
        self.target = target
        self.action = action
        self.style = style
        
        super.init(title: title)
    }
    
    func invokeAction() {
        RJTDynamicInvoke.invokeSelector(self.action, onTarget: self.target)
    }
}

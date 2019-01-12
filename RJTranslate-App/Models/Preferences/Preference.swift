//
//  Preference.swift
//  RJTranslate-App
//
//  Created by Даниил on 30/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

enum PreferenceCategory: Int {
    case text
    case `switch`
}

class Preference {
    
    /// Название настройки.
    public var title: String?
    
    public weak var prefsTableModel: PreferencesTableModel?
    
    /// Тип настройки. По умолчанию - текст.
    public var category: PreferenceCategory {
        return .text
    }
}

class StorablePreference: Preference, CustomStringConvertible {
    
    /// Ключ сохраняемой настройки.
    public private(set) var key: String = ""
    
    /// Значение настройки по умолчанию.
    public private(set) var defaultValue: Any?
    
    /// Возвращает сохраненное значение из настроек или значение по умолчанию.
    public var value: Any? {
        let value: Any? = UserDefaults.standard.object(forKey: key)
        return value ?? defaultValue
    }
    
    var description: String {
        return String(format: "<%@; title: '%@'; key: '%@'; value: %@; default: %@>",
                      NSStringFromClass(type(of: self)), title ?? "",
                      key, String(describing: value), String(describing: defaultValue))
    }
    
    
    public init(key: String, defaultValue: Any?, title: String?) {
        self.key = key
        self.defaultValue = defaultValue
        
        super.init()
        
        self.title = title
    }
    
    public func save(value: Any?) {
        DispatchQueue.global().async {
            UserDefaults.standard.set(value, forKey: self.key)
           self.prefsTableModel?.delegate?.userDidSetPreferenceValue(value, forKey: self.key)
        }
    }
}


class SwitchPreference: StorablePreference {
    override var category: PreferenceCategory {
        return .switch
    }
}

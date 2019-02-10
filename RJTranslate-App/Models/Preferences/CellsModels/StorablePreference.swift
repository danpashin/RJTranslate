//
//  StorablePreference.swift
//  RJTranslate-App
//
//  Created by Даниил on 30/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class StorablePreference: Preference, CustomStringConvertible {
    
    /// Ключ сохраняемой настройки.
    private(set) var key: String
    
    /// Значение настройки по умолчанию.
    private(set) var defaultValue: Any?
    
    /// Возвращает сохраненное значение из настроек или значение по умолчанию.
    var value: Any? {
        let value = UserDefaults.standard.object(forKey: key)
        return value ?? self.defaultValue
    }
    
    var description: String {
        return String(format: "<%@; title: '%@'; key: '%@'; value: %@; default: %@>",
                      classInfo(self), self.title ?? "",
                      self.key, String(describing: self.value), String(describing: self.defaultValue))
    }
    
    
    init(key: String, defaultValue: Any?, title: String?) {
        self.key = key
        self.defaultValue = defaultValue
        
        super.init(title: title)
    }
    
    func save(value: AnyHashable?) {
        DispatchQueue.global().async {
            UserDefaults.standard.set(value, forKey: self.key)
            self.prefsTableModel?.delegate?.didSetPreferenceValue(value, forKey: self.key)
        }
    }
}


class SwitchPreference: StorablePreference {
    override var category: Preference.Category {
        return .switch
    }
}

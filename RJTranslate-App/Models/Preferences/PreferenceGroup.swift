//
//  PreferenceGroup.swift
//  RJTranslate-App
//
//  Created by Даниил on 30/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

class PreferenceGroup: CustomStringConvertible {
    
    /// Имя группы.
    public private(set) var title: String?
    
    /// Нижний текст (подпись).
    public private(set) var footerText: String?
    
    ///  Массив настроек в группе.
    public private(set) var preferences: [Preference]
    
    var description: String {
        return String(format: "<%@; title: '%@'; footerText: '%@'; prefs: %@>", classInfo(of: self),
                      self.title ?? "", self.footerText ?? "", self.preferences)
    }
    
    public init(title: String?, footerText: String?,  preferences: [Preference] ) {
        self.title = title
        self.footerText = footerText
        self.preferences = preferences
    }
}

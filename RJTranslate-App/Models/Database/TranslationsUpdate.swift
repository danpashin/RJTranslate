//
//  TranslationsUpdate.swift
//  RJTranslate-App
//
//  Created by Даниил on 29/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

public class TranslationsUpdate {
    
    /// Флаг определяет, должно ли производится обновление на данный момент.
    public private(set) var canUpdate: Bool = false
    
    /// Содержит хэш-сумму обновления.
    public private(set) var hashSum: String?
    
    /// Адрес загрузки нового обновления.
    public private(set) var archiveURL: URL?
    
    private static let updatePreferenceKey = "latestTranslationsUpdateHash"
    
    init(dictionary: [String : AnyHashable]?) {
        if dictionary == nil {
            return
        }
        
        self.hashSum = dictionary!["hash_sum"] as? String
        
        if let stringURL: String = dictionary!["archive"] as? String {
            self.archiveURL = URL(string: stringURL)
        }
        
        if let savedHash: String = UserDefaults.standard.string(forKey: TranslationsUpdate.updatePreferenceKey) {
            self.canUpdate = (self.hashSum != savedHash)
        } else if hashSum?.count ?? 0 > 0 {
            self.canUpdate = true
        }
    }
    
    public func saveUpdate() {
        UserDefaults.standard.set(self.hashSum, forKey: TranslationsUpdate.updatePreferenceKey)
    }
}

extension TranslationsUpdate: CustomStringConvertible {
    public var description: String {
        return String(format: "<%@ url: '%@'; hash: '%@'>", classInfo(of: self),
                      String(describing: self.archiveURL), String(describing: self.hashSum))
    }
}

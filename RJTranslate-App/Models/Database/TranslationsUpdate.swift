//
//  TranslationsUpdate.swift
//  RJTranslate-App
//
//  Created by Даниил on 29/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

@objc class TranslationsUpdate: NSObject {
    
    /// Флаг определяет, должно ли производится обновление на данный момент.
    @objc public private(set) var canUpdate: Bool = false
    
    /// Содержит хэш-сумму обновления.
    @objc public private(set) var hashSum: String?
    
    /// Адрес загрузки нового обновления.
    @objc public private(set) var archiveURL: URL?
    
    private static let updatePreferenceKey = "latestTranslationsUpdateHash"
    
    @objc public class func from(dictionary: Dictionary<AnyHashable, Any>?) -> TranslationsUpdate? {
        if dictionary == nil {
            return nil
        }
        
        return TranslationsUpdate.init(dictionary: dictionary!)
    }
    
    init(dictionary: Dictionary<AnyHashable, Any>) {
        hashSum = dictionary["hash_sum"] as? String
        
        if let stringURL: String = dictionary["archive"] as? String {
            archiveURL = URL.init(string: stringURL)
        }
        
        if let savedHash: String = UserDefaults.standard.string(forKey: TranslationsUpdate.updatePreferenceKey) {
            canUpdate = (hashSum != savedHash)
        } else if hashSum?.count ?? 0 > 0 {
            canUpdate = true
        }
        
        super.init()
    }
    
    @objc public func saveUpdate() {
        UserDefaults.standard.set(hashSum, forKey: TranslationsUpdate.updatePreferenceKey)
    }
    
    override var description: String {
        return String(format: "<%@: %p> url: '%@'; hash: '%@'", NSStringFromClass(type(of: self)), self,
                      String(describing: archiveURL), hashSum ?? "")
    }
}

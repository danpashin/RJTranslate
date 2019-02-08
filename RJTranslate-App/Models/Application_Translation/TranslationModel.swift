//
//  TranslationModel.swift
//  RJTranslate-App
//
//  Created by Даниил on 04/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

@objc class TranslationModel: NSObject {
    
    private enum DictionaryKey: String {
        case displayedName = "Displayed Name"
        case bundleIdentifier = "Bundle Identifier"
        case executableName = "Executable Name"
        case executablePath = "Executable Path"
        case updateDate = "Date"
        case translations = "Translations"
        case iconPath = "Icon"
        case forceLocalize = "Force"
    }
    
    /// Отображаемое пользователю имя приложения.
    @objc private(set) var displayedName: String
    
    /// Уникальный идентификатор бандла приложения.
    @objc private(set) var bundleIdentifier: String?
    
    /// Имя выполняемого файла приложения.
    @objc private(set) var executableName: String?
    
    /// Полный путь в бинарному файлу приложения.
    @objc private(set) var executablePath: String?
    
    /// Словарь с переводами строк.
    @objc private(set) var translation: [String: String]?
    
    /// Путь в файловой системе к иконке приложения.
    @objc private(set) var iconPath: String?
    
    /// Флаг определяет, должен ли перевод быть включен. Определяется самим пользователем.
    @objc var enable: Bool
    
    /// Флаг определяет, должен ли выполняться принудительный перевод приложения.
    @objc var forceLocalize: Bool
    
    /// Определяет, существует ли приложение в файлововй системе.
    @objc lazy var appInstalled: Bool = {
        if self.executablePath?.count ?? 0 > 0 {
            return FileManager.default.fileExists(atPath: self.executablePath!)
        } else if self.bundleIdentifier?.count ?? 0 > 0 {
            return (Bundle(identifier: self.bundleIdentifier!) != nil)
        }
        
        return false
    }()
    
    /// Определяет, является ли модель легковесной (без локализации)
    @objc private(set) var lightweightModel: Bool
    
    /// Дата обновления перевода на сервере.
    @objc private(set) var remoteUpdateDate: Date
    
    /// Выполняет инициализацию модели из сущности базы данных.
    ///
    /// - Parameter entity: Сущность базы данных для копирования.
    /// - Returns: Возвращает экземпляр класса для дальнейшей работы.
    @objc init(entity: RJTApplicationEntity, lightweight: Bool = false) {
        self.displayedName = entity.displayedName
        self.bundleIdentifier = entity.bundleIdentifier
        self.executablePath = entity.executablePath
        self.executableName = entity.executableName
        self.remoteUpdateDate = Date(timeIntervalSince1970: entity.remoteUpdateDate)
        
        self.lightweightModel = lightweight
        if !lightweight {
            self.translation = entity.translation
        }
        
        self.enable = entity.enable
        self.forceLocalize = entity.forceLocalize
    }
    
    @objc init?(dictionary: [String: AnyHashable]) {
        if dictionary[DictionaryKey.displayedName.rawValue] == nil { return nil }
        
        self.displayedName = dictionary[DictionaryKey.displayedName.rawValue] as! String
        self.bundleIdentifier = dictionary[DictionaryKey.bundleIdentifier.rawValue] as? String
        self.executableName = dictionary[DictionaryKey.executableName.rawValue] as? String
        self.executablePath = dictionary[DictionaryKey.executablePath.rawValue] as? String
        
        let timeInterval = (dictionary[DictionaryKey.updateDate.rawValue] as? TimeInterval) ?? 0
        self.remoteUpdateDate = Date(timeIntervalSince1970: timeInterval)
        
        self.iconPath = dictionary[DictionaryKey.iconPath.rawValue] as? String
        self.forceLocalize = (dictionary[DictionaryKey.forceLocalize.rawValue] as? Bool) ?? false
        self.enable = false
        self.lightweightModel = false
        
        var translation: [String : String] = [:]
        if let translationDict = dictionary[DictionaryKey.translations.rawValue] as? [[String? : String?]?] {
            for translatedLine in translationDict {
                let original = translatedLine?["key"] as? String
                let translated = translatedLine?["string"] as? String
                if original == nil || translated == nil { continue }
                
                translation[original!] = translated!
            }
        }
        
        self.translation = translation
    }
    
    @objc override func isEqual(_ object: Any?) -> Bool {
        guard let model = object as? TranslationModel else { return false }
        
        return self.displayedName == model.displayedName
    }
}

extension TranslationModel {
    override var description: String {
        return String(format: "<%@; name: %@ (%@ - %@), enable: \(self.enable); server updated: \(self.remoteUpdateDate)>",
        classInfo(self), self.displayedName, self.executableName ?? "", self.bundleIdentifier ?? "")
    }
}

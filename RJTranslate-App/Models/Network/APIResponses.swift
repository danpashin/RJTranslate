//
//  APIResponses.swift
//  RJTranslate-App
//
//  Created by Даниил on 06/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

public struct API {
    public static let apiURL = URL(string: "http://translations.rejail.ru/index.php")!
    
    public struct Error {
        var code: Int
        var description: String
        
        var nserror: NSError {
            let localizedDescription = NSLocalizedString(self.description, comment: "Server description error")
            
            return NSError(domain: "ru.danpashin.rjtranslate.server", code: self.code, 
                           userInfo: [NSLocalizedDescriptionKey: localizedDescription])
        }
    }
    
    public struct SearchableTranslation: CustomStringConvertible {
        
        /// Текст, который использовался для поиска локализации
        public private(set) var searchText: String
        
        /// Имя локализации
        public private(set) var name: String
        
        /// Ссылка на загрузку полной локализации
        public private(set) var url: URL
        
        init(name: String, url: URL, searchText: String) {
            self.name = name
            self.url = url
            self.searchText = searchText
        }
        
        public var description: String {
            return String(format: "<%@; name: %@; url: %@>", classInfo(of: self as AnyObject),
                          String(describing: self.name), String(describing: self.url))
        }
    }
    
    public struct SearchResponse {
        public private(set) var results = [SearchableTranslation]()
        
        public init(json: [String : AnyHashable], searchText: String) {
            if let response = json["response"] as? [[String : AnyHashable]] {
                for result in response {
                    guard let translationName = result["Name"] as? String else { continue }
                    guard var stringURL = result["Translate"] as? String else { continue }
                    stringURL = stringURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    guard let translationURL = URL(string: stringURL) else { continue }
                    
                    let translation = API.SearchableTranslation(name: translationName, url: translationURL, searchText: searchText)
                    self.results.append(translation)
                }
            } else {
                
            }
        }
    }
}


public struct TranslationServerResponse {
    
    public private(set) var translation: TranslationsUpdate?
    public private(set) var error: API.Error?
    
    init(json: [String : AnyHashable]?) {
        
        let errorDict = json!["error"] as? [String : AnyHashable]
        if errorDict != nil {
            let errorCode = errorDict!["code"] as? NSNumber
            let errorDescription = errorDict!["description"] as? String ?? ""
            self.error = API.Error(code: errorCode?.intValue ?? 0, description: errorDescription)
        } else {
            if let translationDict = json!["translation"] as? [String : AnyHashable] {
                self.translation = TranslationsUpdate(dictionary: translationDict)
            } else {
                self.error = API.Error(code: -5, description: "Json parsing failed.")
            }
        }
        
    }
}

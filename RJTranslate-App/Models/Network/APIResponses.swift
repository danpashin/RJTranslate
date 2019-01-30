//
//  APIResponses.swift
//  RJTranslate-App
//
//  Created by Даниил on 06/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

public protocol CustomErrorProtocol {
    var code: Int { get set }
    var description: String { get set }
}

public struct API {
    public static let apiURL = URL(string: "https://translations.rejail.ru/index.php")!
    
    public struct SimpleError: CustomErrorProtocol {
        public var code: Int
        public var description: String
        
        var nserror: NSError {
            let localizedDescription = NSLocalizedString(self.description, comment: "Server description error")
            
            return NSError(domain: "ru.danpashin.rjtranslate.server", code: self.code,
                           userInfo: [NSLocalizedDescriptionKey: localizedDescription])
        }
    }
    
    public struct ResponseResult <T> {
        public var data: T?
        public var error: API.SimpleError?
    }
    
    /// Основная информация о переводе.
    public struct TranslationSummary {
        
        /// Имя локализации
        public private(set) var name: String
        
        /// Текст, который использовался для поиска локализации
        public private(set) var searchText: String
        
        /// Ссылка на загрузку полной локализации
        public private(set) var url: URL
    }
}

public extension API.TranslationSummary {
    
    /// Выполняет живой поиск перевода.
    ///
    /// - Parameters:
    ///   - searchText: Текст для поиска.
    ///   - completion: Блок, который вызывается после выполнения перевода.
    /// - Returns: Возвращает таск запроса.
    @discardableResult
    static func search(text searchText: String,
                                     completion: @escaping (API.ResponseResult <[API.TranslationSummary]>) -> Void)
        -> HTTPJSONTask {
            let task = HTTPClient.shared.json(API.apiURL, arguments: ["action": "search", "name": searchText])
                .completion({ (response: [String : AnyHashable]?, error: NSError?) in
                    var result: API.ResponseResult<[API.TranslationSummary]>!
                    
                    if error == nil && response != nil {
                        result = self.parseSearchResponse(json: response!, searchText: searchText)
                    } else {
                        result = API.ResponseResult<[API.TranslationSummary]>()
                        result.error = API.SimpleError(code: error?.code ?? 0, description: error?.description ?? "")
                        
                        NSLog("Found error while searching live! %@", String(describing: error))
                    }
                    
                    completion(result)
                })
            
            return task
    }
    
    private static func parseSearchResponse(json: [String : AnyHashable], searchText: String)
        -> API.ResponseResult<[API.TranslationSummary]> {
            var parsedSummaries = [API.TranslationSummary]()
            
            if let response = json["response"] as? [[String : AnyHashable]] {
                for result in response {
                    guard let translationName = result["Name"] as? String else { continue }
                    guard var stringURL = result["Translate"] as? String else { continue }
                    stringURL = stringURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    guard let translationURL = URL(string: stringURL) else { continue }
                    
                    let summary = API.TranslationSummary(name: translationName,
                                                         searchText: searchText,
                                                         url: translationURL)
                    parsedSummaries.append(summary)
                }
            } else {
                
            }
            
            return API.ResponseResult<[API.TranslationSummary]>(data: parsedSummaries, error: nil)
    }
}


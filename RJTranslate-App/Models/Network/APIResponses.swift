//
//  APIResponses.swift
//  RJTranslate-App
//
//  Created by Даниил on 06/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

public struct ServerError {
    var code: Int
    var description: String
    
    func asNSError() -> NSError {
        let localizedDescription = NSLocalizedString(self.description, comment: "Server description error")
        
        return NSError(domain: "ru.danpashin.rjtranslate.server", code: self.code, 
                       userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
}


public struct TranslationServerResponse {
    
    public private(set) var translation: TranslationsUpdate?
    public private(set) var error: ServerError?
    
    init(json: [String : AnyHashable]?) {
        
        let errorDict = json!["error"] as? [String : AnyHashable]
        if errorDict != nil {
            let errorCode = errorDict!["code"] as? NSNumber
            let errorDescription = errorDict!["description"] as? String ?? ""
            self.error = ServerError(code: errorCode?.intValue ?? 0, description: errorDescription)
        } else {
            if let translationDict = json!["translation"] as? [String : AnyHashable] {
                self.translation = TranslationsUpdate(dictionary: translationDict)
            } else {
                self.error = ServerError(code: -5, description: "Json parsing failed.")
            }
        }
        
    }
}

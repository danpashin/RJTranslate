//
//  HTTPRequestBuilder.swift
//  RJTranslate-App
//
//  Created by Даниил on 05/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

enum HTTPMethod {
    case get
    case post
}


class HTTPRequestBuilder {
    
    /// Адрес сервера, на который делается запрос.
    public private(set) var url: URLTransformable
    
    ///  Метод запроса. GET или POST.
    public private(set) var httpMethod: HTTPMethod
    
    /// Аргументы для запроса.
    public private(set) var arguments: [String: AnyHashable]
    
    init(url: URLTransformable, httpMethod: HTTPMethod, arguments: [String: AnyHashable]) {
        self.url = url
        self.httpMethod = httpMethod
        self.arguments = arguments
    }
    
    /// Выполняет построение запроса из предоставленных данных.
    ///
    /// - Returns: Возвращает класс запроса либо nil
    public func buildRequest() -> URLRequest  {
        var urlComponents = URLComponents(string: self.url.asString())
        
        let stringParameters = NSMutableString()
        let sortedKeys = self.arguments.keys.sorted(by: <)
        for key in sortedKeys {
            stringParameters.appendFormat("%@=%@&", key, self.arguments[key]! as CVarArg)
        }
        
        while stringParameters.hasSuffix("&") {
            stringParameters.replaceCharacters(in: NSMakeRange(stringParameters.length - 1, 1), with: "")
        }
        
        var bodyData: Data? = nil
        if self.httpMethod == .get {
            if urlComponents?.query == nil {
                urlComponents?.query = stringParameters as String
            } else {
                if urlComponents?.query?.last != "&" && stringParameters.length > 0 {
                    urlComponents?.query?.append("&")
                }
                
                urlComponents?.query?.append(contentsOf: stringParameters as String)
            }
        } else {
            let query = stringParameters.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            bodyData = query?.data(using: .utf8)
        }
        
        var request = URLRequest(url: urlComponents?.url ?? URL(string: "")!)
        request.httpMethod = self.stringFromMethod(self.httpMethod)
        request.httpBody = bodyData
        return request
    }
    
    private func stringFromMethod(_ method : HTTPMethod) -> String {
        switch method {
        case .get:
            return "GET"
            
        case .post:
            return "POST"
            
//        default:
//            return ""
        }
    }
}

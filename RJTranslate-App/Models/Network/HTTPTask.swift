//
//  HTTPTask.swift
//  RJTranslate-App
//
//  Created by Даниил on 05/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation


class HTTPTask {
    
    public private(set) var sessionTask: URLSessionTask
    
    public private(set) var request: URLRequest
    
    init(request: URLRequest, sessionTask: URLSessionTask) {
        self.request = request
        self.sessionTask = sessionTask
    }
}


class HTTPDownloadTask: HTTPTask {
    public typealias downloadProgressClosure = (_ progress: Double) -> Void
    public typealias downloadCompletionClosure = (_ downloadedDataURL : URL?, _ error: NSError?) -> Void
    
    /// Прогресс загрузки файла.
    public private(set) var progressClosure : downloadProgressClosure?
    
    /// Вызывается по окончании загрузки файла.
    public private(set) var completionClosure : downloadCompletionClosure?
    
    @discardableResult
    public func progress(_ progressClosure : @escaping downloadProgressClosure) -> HTTPDownloadTask {
        self.progressClosure = progressClosure
        return self
    }
    
    @discardableResult
    public func completion(_ completionClosure : @escaping downloadCompletionClosure) -> HTTPDownloadTask {
        self.completionClosure = completionClosure
        return self
    }
}


class HTTPJSONTask: HTTPTask {
    public typealias jsonCompletionClosure = (_ json : [String: AnyHashable]?, _ error: NSError?) -> Void
    
    public let responseData: NSMutableData = NSMutableData()
    
    /// Вызывается по окончании сериализации ответа.
    public private(set) var completionClosure : jsonCompletionClosure?
    
    @discardableResult
    public func completion(_ completionClosure : @escaping jsonCompletionClosure) -> HTTPJSONTask {
        self.completionClosure = completionClosure
        return self
    }
    
    /// Выполняет сериализацию полученных данных и вызывает completionClosure.
    public func serialize() {
        DispatchQueue(label: "ru.danpashin.rjtranslate.serialization").async {
            var json: [String: AnyHashable]?
            
            do {
                json = try (JSONSerialization.jsonObject(with: self.responseData as Data, options: []) as? [String : AnyHashable])
            } catch let error {
                let errorObject = appRecordError(error.localizedDescription)
                self.completionClosure?(nil, errorObject)
                return
            }
            
            self.completionClosure?(json, nil)
        }
    }
}

//
//  HTTPTask.swift
//  RJTranslate-App
//
//  Created by Даниил on 05/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation


class HTTPTask {
    
    private(set) var sessionTask: URLSessionTask?
    
    private(set) var request: URLRequest?
    
    init(request: URLRequest?, sessionTask: URLSessionTask?) {
        self.request = request
        self.sessionTask = sessionTask
    }
}


class HTTPDownloadTask: HTTPTask {
    typealias downloadProgressClosure = (_ progress: Double) -> Void
    typealias downloadCompletionClosure = (_ downloadedDataURL : URL?, _ error: NSError?) -> Void
    
    /// Прогресс загрузки файла.
    private(set) var progressClosure: downloadProgressClosure?
    
    /// Вызывается по окончании загрузки файла.
    private(set) var completionClosure: downloadCompletionClosure?
    
    @discardableResult
    func progress(_ progressClosure: @escaping downloadProgressClosure) -> HTTPDownloadTask {
        self.progressClosure = progressClosure
        return self
    }
    
    @discardableResult
    func completion(_ completionClosure: @escaping downloadCompletionClosure) -> HTTPDownloadTask {
        self.completionClosure = completionClosure
        return self
    }
}


class HTTPJSONTask: HTTPTask {
    typealias jsonCompletionClosure = (_ json : [String: AnyHashable]?, _ error: NSError?) -> Void
    
    let responseData: NSMutableData = NSMutableData()
    
    /// Вызывается по окончании сериализации ответа.
    private(set) var completionClosure: jsonCompletionClosure?
    
    @discardableResult
    func completion(_ completionClosure: @escaping jsonCompletionClosure) -> HTTPJSONTask {
        self.completionClosure = completionClosure
        return self
    }
    
    /// Выполняет сериализацию полученных данных и вызывает completionClosure.
    func serialize() {
        DispatchQueue.global(qos: .default).async {
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

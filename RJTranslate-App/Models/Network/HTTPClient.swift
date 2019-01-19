//
//  HTTPClient.swift
//  RJTranslate-App
//
//  Created by Даниил on 05/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class HTTPClient {
    
    public static let shared: HTTPClient = HTTPClient()
    public static let apiURL: URLTransformable = URL(string: "https://api.rejail.ru/translation.php")!
    
    private var session: URLSession?
    private var configuration: URLSessionConfiguration?
    private var delegateObject: HTTPClientDelegateObject?
    
    public private(set) var activeTasks : [Int: HTTPTask] = [:]
    
    private var defaultUserAgent: String {
        let device = UIDevice.current
        let systemName = device.systemName
        let systemVersion = device.systemVersion
        let deviceIdentifier = device.identifier
        
        var appVersion: String {
            guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") else { return "" }
            return version as? String ?? ""
        }
        
        return String(format: "RJTranslate/%@ (%@; %@/%@; Scale/%.1f)", 
                      appVersion, deviceIdentifier, systemName, systemVersion, UIScreen.main.scale)
    }
    
    public init() {
        self.configuration = URLSessionConfiguration.ephemeral
        self.configuration!.allowsCellularAccess = true
        self.configuration!.httpAdditionalHeaders = ["User-Agent": self.defaultUserAgent]
        
        self.delegateObject = HTTPClientDelegateObject(client: self)
        self.session = URLSession(configuration: self.configuration!, delegate: self.delegateObject, 
                                  delegateQueue: self.delegateObject?.utilityQueue)
    }
    
    /// Выполняет удаление задания с указанным идентификатором
    ///
    /// - Parameter identifier: Идентификатор задания для удаления
    public func removeTask(identifier: Int) {
        self.activeTasks.removeValue(forKey: identifier)
    }
    
    /// Выполняет загрузку файла с удаленного сервера.
    ///
    /// - Parameters:
    ///   - url: Адрес удаленного сервера.
    ///   - httpMethod: Метод запроса. По умолчанию, GET.
    ///   - arguments: Аргументы запроса. По умолчанию, пустой массив.
    /// - Returns: Возвращает объект запроса для дальнейшей работы.
    @discardableResult
    public func download(_ url: URLTransformable,
                         httpMethod: HTTPMethod = .get,
                         arguments:[String: AnyHashable] = [:]
        ) -> HTTPDownloadTask {
        
        let requestBuilder = HTTPRequestBuilder(url: url, httpMethod: httpMethod, arguments: arguments)
        let request = requestBuilder.buildRequest()
        
        let dataTask = self.session!.dataTask(with: request)
        
        let httpTask = HTTPDownloadTask(request: request, sessionTask: dataTask)
        self.activeTasks[dataTask.taskIdentifier] = httpTask
        dataTask.resume()
        
        return httpTask
    }
    
    /// Отправляет запрос на удаленный сервер и получает в ответе json
    ///
    /// - Parameters:
    ///   - url: Адрес удаленного сервера.
    ///   - httpMethod: Метод запроса. По умолчанию, GET.
    ///   - arguments: Аргументы запроса. По умолчанию, пустой массив.
    /// - Returns: Возвращает объект запроса для дальнейшей работы.
    public func json(_ url: URLTransformable,
                     httpMethod: HTTPMethod = .get,
                     arguments:[String: AnyHashable] = [:]
        ) -> HTTPJSONTask? {
        
        let requestBuilder = HTTPRequestBuilder(url: url, httpMethod: httpMethod, arguments: arguments)
        let request = requestBuilder.buildRequest()
        
        let dataTask = self.session!.dataTask(with: request)
        
        let httpTask = HTTPJSONTask(request: request, sessionTask: dataTask)
        self.activeTasks[dataTask.taskIdentifier] = httpTask
        dataTask.resume()
        
        return httpTask
    }
}

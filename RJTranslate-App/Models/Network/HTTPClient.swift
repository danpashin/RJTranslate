//
//  HTTPClient.swift
//  RJTranslate-App
//
//  Created by Даниил on 05/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class HTTPClient: NSObject, URLSessionDownloadDelegate, URLSessionDataDelegate {
    
    public static let shared: HTTPClient = HTTPClient()
    public static var apiURL: URLTransformable {
        return URL(string: "https://api.rejail.ru/translation.php")!
    }
    
    private var session: URLSession?
    private var configuration: URLSessionConfiguration?
    
    private var activeTasks : [Int: HTTPTask] = [:]
    
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
    
    override init() {
        super.init()
        
        self.configuration = URLSessionConfiguration.ephemeral
        self.configuration!.allowsCellularAccess = true
        self.configuration!.httpAdditionalHeaders = ["User-Agent": self.defaultUserAgent]
        
        self.session = URLSession(configuration: self.configuration!, delegate: self, delegateQueue: nil)
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
        ) -> HTTPDownloadTask? {
        
        let requestBuilder = HTTPRequestBuilder(url: url, httpMethod: httpMethod, arguments: arguments)
        guard let request = requestBuilder.buildRequest() else { return nil }
        
        let downloadTask = self.session!.downloadTask(with: request)
        
        let httpTask = HTTPDownloadTask(request: request, sessionTask: downloadTask)
        self.activeTasks[downloadTask.taskIdentifier] = httpTask
        downloadTask.resume()
        
        return httpTask
    }
    
    public func json(_ url: URLTransformable,
                     httpMethod: HTTPMethod = .get,
                     arguments:[String: AnyHashable] = [:]
        ) -> HTTPJSONTask? {
        
        let requestBuilder = HTTPRequestBuilder(url: url, httpMethod: httpMethod, arguments: arguments)
        guard let request = requestBuilder.buildRequest() else { return nil }
        
        let dataTask = self.session!.dataTask(with: request)
        
        let httpTask = HTTPJSONTask(request: request, sessionTask: dataTask)
        self.activeTasks[dataTask.taskIdentifier] = httpTask
        dataTask.resume()
        
        return httpTask
    }
    
    
    // MARK: -
    // MARK: URLSessionTaskDelegate
    
    public func urlSession(_ session: URLSession, task sessionTask: URLSessionTask, didCompleteWithError error: Error?) {
        guard let task = self.activeTasks[sessionTask.taskIdentifier] else { return }
        
        if let jsonTask = task as? HTTPJSONTask {
            jsonTask.serialize()
        }
        
        self.activeTasks.removeValue(forKey: sessionTask.taskIdentifier)
    }
    
    
    // MARK: -
    // MARK: URLSessionDataDelegate
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, 
                           didReceive response: URLResponse, 
                           completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let httpResponse = response as! HTTPURLResponse
        
        guard let task = self.activeTasks[dataTask.taskIdentifier] else {
            completionHandler(.cancel)
            return
        }
        
        if let jsonTask = task as? HTTPJSONTask {
            let shouldLoad = (httpResponse.mimeType?.contains("json") ?? false && (200...399) ~= httpResponse.statusCode)
            completionHandler(shouldLoad ? .allow : .cancel)
            
            if !shouldLoad {
                let error = appRecordError("Load of json task if forbidden")
                jsonTask.completionClosure?(nil, error)
            }
        }
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let task = self.activeTasks[dataTask.taskIdentifier] else { return }
        
        if let jsonTask = task as? HTTPJSONTask {
            jsonTask.responseData.append(data)
        }
    }
    
    
    // MARK: -
    // MARK: URLSessionDownloadDelegate
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let task = self.activeTasks[downloadTask.taskIdentifier] as? HTTPDownloadTask else { return }
        
        let fileName = task.request.url?.lastPathComponent
        let stringNewLocation = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        
        let destination = URL(fileURLWithPath: stringNewLocation!).appendingPathComponent(fileName!)
        
        do {
            try FileManager.default.moveItem(at: location, to: destination)
        } catch let exceptionError {
            let error = NSError(domain: NSCocoaErrorDomain, code: 0, 
                                userInfo: [NSLocalizedDescriptionKey: exceptionError.localizedDescription])
            task.completionClosure?(nil, error)
            return
        }
        
        task.completionClosure?(destination, nil)
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, 
                           didWriteData bytesWritten: Int64, 
                           totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let task = self.activeTasks[downloadTask.taskIdentifier] as? HTTPDownloadTask else { return }
        task.progressClosure?(Double(totalBytesWritten / totalBytesExpectedToWrite))
    }
}

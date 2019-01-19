//
//  HTTPClientDelegateObject.swift
//  RJTranslate-App
//
//  Created by Даниил on 05/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation


class HTTPClientDelegateObject: NSObject, URLSessionDownloadDelegate, URLSessionDataDelegate {
    
    weak public private(set) var client: HTTPClient?
    public private(set) var utilityQueue: OperationQueue
    
    public init(client: HTTPClient) {
        self.client = client
        
        self.utilityQueue = OperationQueue()
        self.utilityQueue.name = "ru.danpashin.rjtranslate.network"
        self.utilityQueue.qualityOfService = .utility
    }
    
    
    // MARK: -
    // MARK: URLSessionTaskDelegate
    
    public func urlSession(_ session: URLSession, task sessionTask: URLSessionTask, didCompleteWithError error: Error?) {
        guard let task = self.client?.activeTasks[sessionTask.taskIdentifier] else { return }
        
        if let jsonTask = task as? HTTPJSONTask {
            jsonTask.serialize()
        }
        
        self.client?.removeTask(identifier: sessionTask.taskIdentifier)
    }
    
    
    // MARK: -
    // MARK: URLSessionDataDelegate
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, 
                           didReceive response: URLResponse, 
                           completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        let httpResponse = response as! HTTPURLResponse
        
        guard let task = self.client?.activeTasks[dataTask.taskIdentifier] else {
            completionHandler(.cancel)
            return
        }
        
        let responseCodeValid = (200...399) ~= httpResponse.statusCode
        
        if let jsonTask = task as? HTTPJSONTask {
            let shouldLoad = (httpResponse.mimeType?.contains("json") ?? false && responseCodeValid)
            completionHandler(shouldLoad ? .allow : .cancel)
            
            if !shouldLoad {
                let error = appRecordError("Response code (%i) or mime type (%@) is invalid for json task", 
                                           httpResponse.statusCode, httpResponse.mimeType ?? "")
                jsonTask.completionClosure?(nil, error)
            }
        } else if let downloadTask = task as? HTTPDownloadTask {
            completionHandler(responseCodeValid ? .becomeDownload : .cancel)
            
            if !responseCodeValid {
                let error = appRecordError("Response code (%i) is invalid for download task", httpResponse.statusCode)
                downloadTask.completionClosure?(nil, error)
            }
        }
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let task = self.client?.activeTasks[dataTask.taskIdentifier] else { return }
        
        if let jsonTask = task as? HTTPJSONTask {
            jsonTask.responseData.append(data)
        }
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        downloadTask.resume()
    }
    
    
    // MARK: -
    // MARK: URLSessionDownloadDelegate
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let task = self.client?.activeTasks[downloadTask.taskIdentifier] as? HTTPDownloadTask else { return }
        
        let fileName = task.request?.url?.lastPathComponent
        let stringNewLocation = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        
        let destination = URL(fileURLWithPath: stringNewLocation!).appendingPathComponent(fileName!)
        
        do {
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: destination.path) {
                try? fileManager.removeItem(at: destination)
            }
            
            try fileManager.moveItem(at: location, to: destination)
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
        guard let task = self.client?.activeTasks[downloadTask.taskIdentifier] as? HTTPDownloadTask else { return }
        task.progressClosure?(Double(totalBytesWritten / totalBytesExpectedToWrite))
    }
}

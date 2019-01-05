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
    
    public init(client: HTTPClient) {
        self.client = client
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
        guard let task = self.client?.activeTasks[dataTask.taskIdentifier] else { return }
        
        if let jsonTask = task as? HTTPJSONTask {
            jsonTask.responseData.append(data)
        }
    }
    
    
    // MARK: -
    // MARK: URLSessionDownloadDelegate
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let task = self.client?.activeTasks[downloadTask.taskIdentifier] as? HTTPDownloadTask else { return }
        
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
        guard let task = self.client?.activeTasks[downloadTask.taskIdentifier] as? HTTPDownloadTask else { return }
        task.progressClosure?(Double(totalBytesWritten / totalBytesExpectedToWrite))
    }
}

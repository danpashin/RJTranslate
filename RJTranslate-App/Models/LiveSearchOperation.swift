//
//  LiveSearchOperation.swift
//  RJTranslate-App
//
//  Created by Даниил on 23/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class LiveSearchOperation: AsynchronousOperation {
    private var jsonTask: HTTPJSONTask?
    
    private var searchText: String
    
    /// Результат выполненного запроса.
    public private(set) var result: API.SearchResponse!
    
    public init(searchText: String) {
        self.searchText = searchText
    }
    
    /// Выполняет асинхронный запрос на сервер и возвращает ответ в распарсенном виде.
    override public func main() {
        super.main()
        
        if self.isCancelled {
            self.state = .finished
            return
        }
        
        self.jsonTask = HTTPClient.shared.json(API.apiURL, arguments: ["action": "search", "name": self.searchText])
            .completion({ (response: [String : AnyHashable]?, error: NSError?) in
                if error == nil && response != nil {
                    self.result = API.SearchResponse(json: response!, searchText: self.searchText)
                } else {
                    NSLog("Found error while searching live! %@", String(describing: error))
                }
                
                self.state = .finished
            })
    }
    
    /// Отменяет запрос и асинхронную операцию.
    override public func cancel() {
        super.cancel()
        
        if let task = self.jsonTask?.sessionTask {
            HTTPClient.shared.removeTask(identifier: task.taskIdentifier)
            task.cancel()
            self.jsonTask = nil
        }
    }
}

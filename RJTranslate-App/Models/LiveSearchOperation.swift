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
    public private(set) var result: API.ResponseResult<[API.TranslationSummary]>?
    
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
        
        self.jsonTask = API.TranslationSummary.search(text: self.searchText) {
            (searchResult: API.ResponseResult<[API.TranslationSummary]>) in
            self.result = searchResult
            
            self.state = .finished
        }
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

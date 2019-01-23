//
//  SearchResultsTableModel.swift
//  RJTranslate-App
//
//  Created by Даниил on 23/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

public class SearchResultsTableModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    public private(set) var searhResults = [API.SearchableTranslation]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    public var tableView: SearchResultsTableView? {
        didSet {
            self.tableView?.delegate = self
            self.tableView?.dataSource = self
        }
    }
    
    private let syncOperationQueue = OperationQueue()
    
    public override init() {
        self.syncOperationQueue.name = "ru.danpashin.rjtranslate.livesearch"
        self.syncOperationQueue.maxConcurrentOperationCount = 1
        self.syncOperationQueue.qualityOfService = .userInitiated
    }
    
    /// Выполняет асинхронный поиск на сервере.
    ///
    /// - Parameter text: Текст для поиска.
    public func performSearch(text: String) {
        self.searhResults.removeAll()
        self.syncOperationQueue.cancelAllOperations()
        
        let operation = LiveSearchOperation(searchText: text)
        operation.completionBlock = {
            self.updateForResult(operation.result)
        }
        
        self.syncOperationQueue.addOperation(operation)
    }
    
    private func updateForResult(_ result: API.SearchResponse) {
        self.searhResults.removeAll()
        self.searhResults.append(contentsOf: result.results)
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searhResults.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SearchResultCell(style: .default, reuseIdentifier: "resultCell")
        cell.result = self.searhResults[indexPath.row]
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
}

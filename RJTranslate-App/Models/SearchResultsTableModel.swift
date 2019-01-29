//
//  SearchResultsTableModel.swift
//  RJTranslate-App
//
//  Created by Даниил on 23/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

public class SearchResultsTableModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    public private(set) var searchResults = [API.TranslationSummary]()
    
    public weak var tableView: SearchResultsTableView? {
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
        self.syncOperationQueue.cancelAllOperations()
        self.searchResults.removeAll()
        
        self.tableView?.reloadData()
        self.tableView?.startRefreshing()
        
        let operation = LiveSearchOperation(searchText: text)
        operation.completionBlock = {
            self.updateForResult(operation.result)
        }
        
        self.syncOperationQueue.addOperation(operation)
    }
    
    private func updateForResult(_ result: API.ResponseResult<[API.TranslationSummary]>?) {
        self.searchResults.removeAll()
        
        if let data = result?.data {
            self.searchResults.append(contentsOf: data)
        }
        
        self.tableView?.stopRefreshing()
        self.tableView?.reloadData()
    }
    
    
    // MARK: -
    // MARK: UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SearchResultCell(style: .default, reuseIdentifier: "resultCell")
        cell.result = self.searchResults[indexPath.row]
        
        return cell
    }
    
    
    // MARK: -
    // MARK: UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.hideKeyboard()
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = self.searchResults[indexPath.row]
        let detailController = TranslationDetailController(translationSummary: result)
        
        let navController = UIApplication.applicationDelegate.currentNavigationController
        navController.pushViewController(detailController, animated: true)
    }
}

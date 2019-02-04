//
//  LiveSearchResultsController.swift
//  RJTranslate-App
//
//  Created by Даниил on 22/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class LiveSearchResultsController : SimpleViewController, SearchControllerDelegate {
    
    private var resultsHiddenBottomConstraint: NSLayoutConstraint!
    private var resultsOpenedBottomConstraint: NSLayoutConstraint!
    
    private var resultsPresented = false
    
    /// Таблица, используемая для показа результатов поиска.
    let resultsTableView = SearchResultsTableView()
    private(set) var searchController: SearchControllerRequired?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.resultsTableView)
        
        self.resultsTableView.translatesAutoresizingMaskIntoConstraints = false
        self.resultsTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.resultsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.resultsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.resultsOpenedBottomConstraint = self.resultsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        self.resultsHiddenBottomConstraint = self.resultsTableView.bottomAnchor.constraint(equalTo: self.view.topAnchor)
        self.resultsHiddenBottomConstraint.isActive = true
        
        if #available(iOS 11.0, *) {
            let modernSearch = ModernSearchController(delegate: self)
            self.resultsTableView.model.searchController = modernSearch
            
            self.searchController = modernSearch
            self.navigationItem.searchController = self.searchController as! ModernSearchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            let obsoleteSearch = ObsoleteSearchController(delegate: self)
            self.searchController = obsoleteSearch
            self.resultsTableView.model.searchController = obsoleteSearch
            
            if let navBar = self.navigationController?.navigationBar {
                self.navigationItem.titleView = obsoleteSearch.createSearchBarForView(navBar)
            }
        }
        
        self.searchController?.dimBackground = false
        
    }
    
    /// Показывает таблицу с результатами поиска.
    func showResults() {
        if !self.resultsPresented {
            self.resultsPresented = true
            self.view.bringSubviewToFront(self.resultsTableView)
            
            self.resultsHiddenBottomConstraint.isActive = false
            self.resultsOpenedBottomConstraint.isActive = true
            
            self.animateResultsTableChange()
        }
    }
    
    /// Скрывает таблицу с результатами поиска.
    func hideResults() {
        if self.resultsPresented {
            self.resultsPresented = false
            
            self.resultsOpenedBottomConstraint.isActive = false
            self.resultsHiddenBottomConstraint.isActive = true
            
            self.animateResultsTableChange()
        }
    }
    
    private func animateResultsTableChange() {
        UIView.animate(withDuration: 0.35) { 
            self.view.layoutIfNeeded()
        }
    }
    
    func searchController(_ searchController: SearchControllerRequired, didUpdateSearchText searchText: String) {
        if searchText.count > 0 {
            self.showResults()
            self.resultsTableView.model.performSearch(text: searchText)
        } else {
            self.hideResults()
        }
    }
    
    func willDismissSearchController(_ searchController: SearchControllerRequired) {
        self.hideResults()
    }
}

//
//  LiveSearchResultsController.swift
//  RJTranslate-App
//
//  Created by Даниил on 22/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

public class LiveSearchResultsController : UIViewController, SearchControllerDelegate {
    
    private var hiddenStateBottomConstraint: NSLayoutConstraint!
    private var openedStateBottomConstraint: NSLayoutConstraint!
    
    private var resultsPresented = false
    
    /// Таблица, используемая для показа результатов поиска.
    private var resultsTableView = SearchResultsTableView()
    private var searchController: SearchControllerRequired?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.resultsTableView)
        
        self.resultsTableView.translatesAutoresizingMaskIntoConstraints = false
        self.resultsTableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.resultsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.resultsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.openedStateBottomConstraint = self.resultsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        self.hiddenStateBottomConstraint = self.resultsTableView.bottomAnchor.constraint(equalTo: self.view.topAnchor)
        self.hiddenStateBottomConstraint.isActive = true
        
        if #available(iOS 11.0, *) {
            let modernSearch = ModernSearchController(delegate: self)
            modernSearch.dimBackground = false
            
            self.searchController = modernSearch
            self.navigationItem.searchController = self.searchController as! ModernSearchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
        }
        
    }
    
    /// Показывает таблицу с результатами поиска.
    public func showResults() {
        if !self.resultsPresented {
            self.resultsPresented = true
            self.view.bringSubviewToFront(self.resultsTableView)
            
            self.hiddenStateBottomConstraint.isActive = false
            self.openedStateBottomConstraint.isActive = true
            
            self.animateResultsTableChange()
        }
    }
    
    /// Скрывает таблицу с результатами поиска.
    public func hideResults() {
        if self.resultsPresented {
            self.resultsPresented = false
            
            self.openedStateBottomConstraint.isActive = false
            self.hiddenStateBottomConstraint.isActive = true
            
            self.animateResultsTableChange()
        }
    }
    
    private func animateResultsTableChange() {
        UIView.animate(withDuration: 0.35) { 
            self.view.layoutIfNeeded()
        }
    }
    
    public func searchController(_ searchController: SearchControllerRequired, didUpdateSearchText searchText: String) {
        if searchText.count > 0 {
            self.showResults()
            self.resultsTableView.model.performSearch(text: searchText)
        } else {
            self.hideResults()
        }
    }
    
    public func willDismissSearchController(_ searchController: SearchControllerRequired) {
        self.hideResults()
    }
}

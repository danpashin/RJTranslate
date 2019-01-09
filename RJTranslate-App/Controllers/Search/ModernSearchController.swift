//
//  SearchController.swift
//  RJTranslate-App
//
//  Created by Даниил on 01/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

@objc public class ModernSearchController: UISearchController, UISearchBarDelegate, SearchControllerRequired {
    
    /// Определяет, должен ли затемняться фон при начале поиска. По умолчанию, true.
    @objc public var dimBackground = true
    
    ///  Возвращает текст поиска, который набирается пользователем.
    @objc public private(set) var searchText: String = ""
    
    /// Определет, выполняется ли поиск в данный момент.
    @objc public private(set) var performingSearch: Bool = false
    
    public weak var searchDelegate: SearchControllerDelegate?
    
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(delegate:) instead")
    }
    
    /// Выполняет инициализацию контроллера поиска.
    ///
    /// - Parameter delegate: Устанавливает делегат для объекта.
    @objc required public init(delegate: SearchControllerDelegate) {
        super.init(searchResultsController: nil)
        
        self.searchDelegate = delegate
        self.delegate = delegate
        
        self.dimsBackgroundDuringPresentation = false
        self.searchBar.delegate = self
    }
    
    private func showDimmingView(_ show: Bool) {
        if !self.dimBackground {
            return
        }
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [], animations: {
            self.view.backgroundColor = UIColor(white: 0.0, alpha: show ? 0.3 : 0.0)
        }, completion: nil)
    }
    
    
    // MARK: -
    // MARK: UISearchBarDelegate
    // MARK: -
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.performingSearch = true
        self.showDimmingView(true)
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIApplication.applicationDelegate.tracker?.trackSearchEvent(self.searchText)
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        
        self.showDimmingView((searchText.count == 0))
        self.searchDelegate?.searchController?(self, didUpdateSearchText: searchText)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
        self.performingSearch = false
        self.showDimmingView(false)
    }
}

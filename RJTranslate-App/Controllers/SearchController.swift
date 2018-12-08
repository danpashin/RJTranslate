//
//  SearchController.swift
//  RJTranslate-App
//
//  Created by Даниил on 01/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

@objc(RJTSearchControllerDelegate) public protocol SearchControllerDelegate: UISearchControllerDelegate {
    @objc optional func searchController(_ searchController: SearchController, didUpdateSearchText searchText: String)
}

@objc(RJTSearchController) public class SearchController: UISearchController, UISearchBarDelegate {
    
    /// Определяет, должен ли затемняться фон при начале поиска. По умолчанию, true.
    @objc public var dimBackground = true
    
    ///  Возвращает текст поиска, который набирается пользователем.
    @objc public private(set) var searchText: String = ""
    
    /// Определет, выполняется ли поиск в данный момент.
    @objc public private(set) var performingSearch: Bool = false
    
    private weak var searchDelegate: SearchControllerDelegate?
    
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(delegate:) instead")
    }
    @available(*, unavailable)
    override public init(searchResultsController: UIViewController?) {
        fatalError("Use init(delegate:) instead")
    }
    
    @available(*, unavailable)
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /// Выполняет инициализацию контроллера поиска.
    ///
    /// - Parameter delegate: Устанавливает делегат для объекта.
    @objc public init(delegate: SearchControllerDelegate) {
        super.init(searchResultsController: nil)
        
        self.searchDelegate = delegate
        self.delegate = delegate
        
        self.dimsBackgroundDuringPresentation = false
        self.searchBar.delegate = self
        
        if #available(iOS 11.0, *) {
        } else {
            self.hidesNavigationBarDuringPresentation = false
            
            let searchField: UITextField? = self.searchBar.searchTextField
            searchField?.layer.cornerRadius = 8.0
            searchField?.layer.masksToBounds = false
            searchField?.backgroundColor = UIColor(red: 0.0, green: 0.027, blue: 0.098, alpha: 0.08)
            
        }
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

public extension UISearchBar {
    public var searchTextField: UITextField? {
        return self.value(forKey: "searchField") as? UITextField
    }
}

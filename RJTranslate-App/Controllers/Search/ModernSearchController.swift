//
//  SearchController.swift
//  RJTranslate-App
//
//  Created by Даниил on 01/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

class ModernSearchController: UISearchController, UISearchBarDelegate, SearchControllerRequired, UISearchControllerDelegate {
    
    /// Определяет, должен ли затемняться фон при начале поиска. По умолчанию, true.
    var dimBackground = true
    
    ///  Возвращает текст поиска, который набирается пользователем.
    private(set) var searchText: String = ""
    
    /// Определет, выполняется ли поиск в данный момент.
    private(set) var performingSearch: Bool = false
    
    weak var searchDelegate: SearchControllerDelegate!
    
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @available(*, unavailable)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    /// Выполняет инициализацию контроллера поиска.
    ///
    /// - Parameter delegate: Устанавливает делегат для объекта.
    required  init(delegate: SearchControllerDelegate) {
        super.init(searchResultsController: nil)
        
        self.searchDelegate = delegate
        self.delegate = self
        
        self.dimsBackgroundDuringPresentation = false
        self.searchBar.delegate = self
        self.searchBar.tintColor = ColorScheme.default.navTint
    }
    
    private func showDimmingView(_ show: Bool) {
        if !self.dimBackground {
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.0,
                       options: [.allowUserInteraction, .allowAnimatedContent], animations: {
                        self.view.backgroundColor = UIColor(white: 0.0, alpha: show ? 0.3 : 0.0)
        }, completion: nil)
    }
    
    
    // MARK: -
    // MARK: UISearchBarDelegate
    // MARK: -
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.performingSearch = true
        self.showDimmingView(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIApplication.applicationDelegate.tracker?.trackSearchEvent(self.searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        
        self.showDimmingView((searchText.count == 0))
        self.searchDelegate?.searchController?(self, didUpdateSearchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
        self.performingSearch = false
        self.showDimmingView(false)
    }
    
    
    // MARK: -
    // MARK: UISearchControllerDelegate
    
    func willPresentSearchController(_ searchController: UISearchController) {
        self.searchDelegate?.willPresentSearchController?(self)
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        self.searchDelegate?.didPresentSearchController?(self)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.searchDelegate?.willDismissSearchController?(self)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.searchDelegate?.didDismissSearchController?(self)
    }
}

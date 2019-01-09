//
//  ObsoleteSearchController.swift
//  RJTranslate-App
//
//  Created by Даниил on 08/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation


@objc class ObsoleteSearchController: UIViewController, SearchControllerRequired {
    @objc public private(set) var searchText: String = ""
    
    @objc public private(set) weak var searchDelegate: SearchControllerDelegate?
    
    @objc public private(set) var searchBar: ButtonedSearchBar?
    
    /// Определет, выполняется ли поиск в данный момент.
    @objc public private(set) var performingSearch: Bool = false
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(delegate: SearchControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        
        self.searchDelegate = delegate
    }
    
    @objc public func createSearchBarForView(_ view: UIView) -> ButtonedSearchBar {
        self.searchBar = ButtonedSearchBar(frame: view.bounds)
        return self.searchBar!
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

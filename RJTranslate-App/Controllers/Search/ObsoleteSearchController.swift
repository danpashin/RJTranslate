//
//  ObsoleteSearchController.swift
//  RJTranslate-App
//
//  Created by Даниил on 08/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation


@objc class ObsoleteSearchController: UIViewController, SearchControllerRequired, UISearchBarDelegate {
    @objc public private(set) var searchText: String = ""
    
    @objc public private(set) weak var searchDelegate: SearchControllerDelegate?
    
    @objc public private(set) var searchBar: ButtonedSearchBar?
    
    /// Определет, выполняется ли, поиск в данный момент.
    @objc public private(set) var performingSearch: Bool = false {
        didSet {
            self.searchBar?.showCancelButton = self.performingSearch
        }
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(delegate: SearchControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        
        self.searchDelegate = delegate
        self.modalPresentationStyle = .overFullScreen
    }
    
    @objc public func createSearchBarForView(_ view: UIView) -> ButtonedSearchBar {
        self.searchBar = ButtonedSearchBar(frame: view.bounds)
        self.searchBar?.delegate = self
        return self.searchBar!
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(String(describing: self.view.superview))")
    }
    
    private func present() {
        if let navbar = UINavigationBar.getFirstBar() {
            navbar.superview?.insertSubview(self.view, belowSubview: navbar)
        }
    }
    
    private func dismiss() {
        self.view.removeFromSuperview()
        self.view = nil
    }
    
    
    // MARK: -
    // MARK: UISearchBarDelegate
    // MARK: -
    
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.present()
//       let rootController = UIApplication.shared.keyWindow?.rootViewController
        
//        rootController?.present(self, animated: true, completion: nil)
//        rootController.
        
        return true
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.performingSearch = true
//        self.showDimmingView(true)
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIApplication.applicationDelegate.tracker?.trackSearchEvent(self.searchText)
        
        self.dismiss()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        
//        self.showDimmingView((searchText.count == 0))
        self.searchDelegate?.searchController?(self, didUpdateSearchText: searchText)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
        self.performingSearch = false
//        self.showDimmingView(false)
    }
    
}

public extension UINavigationBar {
    static func getFirstBar() -> UINavigationBar? {
        let window = UIApplication.shared.keyWindow
        
        let view: UIView? = window
        while ((view?.subviews) != nil) {
            for subview in view!.subviews {
                if subview is UINavigationBar {
                    return subview as? UINavigationBar
                }
            }
        }
        
        return nil
    }
    
    static func recursiveSearchView(_ view: UIView, viewType: AnyObject) -> UIView? {
        while view.subviews.count > 0 {
            for subview in view.subviews {
                if subview is viewType {

                }
            }
        }
        
        return nil
    }
}

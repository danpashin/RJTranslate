//
//  ObsoleteSearchController.swift
//  RJTranslate-App
//
//  Created by Даниил on 08/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation


class ObsoleteSearchController: UIViewController, SearchControllerRequired, UISearchBarDelegate {
     var dimBackground: Bool = true
    
    private(set) var searchText: String = ""
    
    private(set) weak var searchDelegate: SearchControllerDelegate!
    
    private(set) var searchBar: ButtonedSearchBar?
    
   private var dimmed: Bool = true
    
    /// Определет, выполняется ли, поиск в данный момент.
    private(set) var performingSearch: Bool = false {
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
    
    func createSearchBarForView(_ view: UIView) -> ButtonedSearchBar {
        self.searchBar = ButtonedSearchBar(frame: view.bounds)
        self.searchBar?.delegate = self
        return self.searchBar!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    /// Выполняет презентацию контроллера на экране
   private func present() {
        self.searchDelegate?.willPresentSearchController?(self)
        if self.performingSearch {
            self.dismiss()
        }
        
        self.performingSearch = true
        
        if let navbar = UINavigationBar.getFirstBar() {
            navbar.superview?.insertSubview(self.view, belowSubview: navbar)
        }
        self.searchDelegate?.didPresentSearchController?(self)
    }
    
    /// Удаляет контроллер с экрана
   private func dismiss(_ notifyDelegate: Bool = true) {
        if self.performingSearch {
            if notifyDelegate {
                self.searchDelegate?.willDismissSearchController?(self)
            }
            
            self.searchBar?.endEditing(true)
            self.performingSearch = false
            
            self.view.removeFromSuperview()
            self.view = nil
            
            if notifyDelegate {
                self.searchDelegate?.didDismissSearchController?(self)
            }
        }
    }
    
   private func updateDimming(_ shouldDim: Bool) {
        if !self.dimBackground { return }
        
        self.dimmed = shouldDim
        if shouldDim {
            self.viewIfLoaded?.isHidden = false
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.viewIfLoaded?.backgroundColor = UIColor(white: 0.0, alpha: shouldDim ? 0.3 : 0.0)
        }) { (animated: Bool) in
            if !shouldDim {
                self.viewIfLoaded?.isHidden = true
            }
        }
    }
    
    @objc private func dimmingViewTapped() {
        if self.performingSearch && self.dimmed {
            self.dismiss(false)
        }
    }
    
    
    // MARK: -
    // MARK: UISearchBarDelegate
    // MARK: -
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if !self.performingSearch {
            self.present()
        }
        
        if self.searchText.count == 0 {
            self.updateDimming(true)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if self.searchText.count > 0 {
            UIApplication.applicationDelegate.tracker?.trackSearchEvent(self.searchText)
        } else {
            self.dismiss()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        
        self.updateDimming((searchText.count == 0))
        self.searchDelegate?.searchController?(self, didUpdateSearchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
        self.dismiss()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

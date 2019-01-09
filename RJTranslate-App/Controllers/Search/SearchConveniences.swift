//
//  SearchConveniences.swift
//  RJTranslate-App
//
//  Created by Даниил on 08/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

@objc public protocol SearchControllerRequired : NSObjectProtocol {
    var searchText: String { get }
    
    weak var searchDelegate: SearchControllerDelegate? { get }
    
    init(delegate: SearchControllerDelegate)
}

@objc public protocol SearchControllerDelegate: UISearchControllerDelegate {
    @objc optional func searchController(_ searchController: SearchControllerRequired, didUpdateSearchText searchText: String)
}


public extension UISearchBar {
    public var searchTextField: UITextField? {
        return self.value(forKey: "searchField") as? UITextField
    }
}

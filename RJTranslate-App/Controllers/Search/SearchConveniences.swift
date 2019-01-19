//
//  SearchConveniences.swift
//  RJTranslate-App
//
//  Created by Даниил on 08/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation


// MARK: -
// MARK: Protocols
// MARK: -

@objc public protocol SearchControllerRequired {
    var searchText: String { get }
    
    var searchDelegate: SearchControllerDelegate? { get }
    
    init(delegate: SearchControllerDelegate)
}

@objc public protocol SearchControllerDelegate {
    
    /// Вызывается перед показом контроллера поиска.
    ///
    /// - Parameter searchController: Экземпляр контроллера поиска, отвечающий на протокол SearchControllerRequired.
    @objc optional func willPresentSearchController(_ searchController: SearchControllerRequired)
    
    /// Вызывается после показа контроллера поиска.
    ///
    /// - Parameter searchController: Экземпляр контроллера поиска, отвечающий на протокол SearchControllerRequired.
    @objc optional func didPresentSearchController(_ searchController: SearchControllerRequired)
    
    /// Вызывается перед удалением контроллера поиска с экрана.
    ///
    /// - Parameter searchController: Экземпляр контроллера поиска, отвечающий на протокол SearchControllerRequired.
    @objc optional func willDismissSearchController(_ searchController: SearchControllerRequired)
    
    /// Вызывается после удаления контроллера поиска с экрана.
    ///
    /// - Parameter searchController: Экземпляр контроллера поиска, отвечающий на протокол SearchControllerRequired.
    @objc optional func didDismissSearchController(_ searchController: SearchControllerRequired)
    
    /// Вызыввается после ввода пользователем текста в баре поиска. 
    ///
    /// - Parameters:
    ///   - searchController: Экземпляр контроллера поиска, отвечающий на протокол SearchControllerRequired.
    ///   - searchText: Новый поисковой запрос.
    @objc optional func searchController(_ searchController: SearchControllerRequired, didUpdateSearchText searchText: String)
}



// MARK: -
// MARK: Extensions
// MARK: -

public extension UINavigationBar {
    public static func getFirstBar() -> UINavigationBar? {
        guard let window = UIApplication.shared.keyWindow else { return nil }
        
        return self.recursiveSearch(in: window, viewType: UINavigationBar.self) as? UINavigationBar
    }
}

public extension UIView {
   public static func recursiveSearch(in view: UIView, viewType: AnyClass) -> UIView? {
        for subview in view.subviews {
            if subview.isKind(of: viewType) {
                return subview
            } else {
                if let navbar = recursiveSearch(in: subview, viewType: viewType) {
                    return navbar
                }
            }
        }
        
        return nil
    }
}

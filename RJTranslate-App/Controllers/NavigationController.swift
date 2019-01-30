//
//  NavigationController.swift
//  RJTranslate-App
//
//  Created by Даниил on 27/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

public class NavigationController: UINavigationController, UINavigationBarDelegate {
    
    override public var navigationBar: NavigationBar {
        return super.navigationBar as! NavigationBar
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.delegate = self
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return ColorScheme.default.statusBarStyle
    }
    
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if self.viewControllers.count < (navigationBar.items?.count ?? 0) {
            return true
        }
        
        if self.topViewController?.controllerShouldPop ?? true {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        }
        
        return false
    }

}

public extension UIViewController {
    @objc var controllerShouldPop: Bool {
        return true
    }
}

//
//  TabbarController.swift
//  RJTranslate-App
//
//  Created by Даниил on 27/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class TabbarController: UITabBarController {
    
    override var tabBar: Tabbar {
        return super.tabBar as! Tabbar
    }
    
    @available(*, deprecated)
    var mainController: TranslateMainController {
        let navigationController = self.viewControllers![0] as! UINavigationController
        return navigationController.viewControllers.first as! TranslateMainController
    }
    
    
}

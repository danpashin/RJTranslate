//
//  NavigationBar.swift
//  RJTranslate-App
//
//  Created by Даниил on 08/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class NavigationBar: UINavigationBar {
   private let defaultShadowImage = UIImage(color: UIColor(white: 0.0, alpha: 0.15))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tintColor = ColorScheme.default.navTint
        self.barTintColor = ColorScheme.default.navBackground
        self.showShadow()
    }
    
    func hideShadow() {
        self.shadowImage = UIImage()
    }
    
    func showShadow() {
        self.shadowImage = self.defaultShadowImage
    }
}

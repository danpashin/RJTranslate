//
//  NavigationBar.swift
//  RJTranslate-App
//
//  Created by Даниил on 08/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class NavigationBar: UINavigationBar {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.barTintColor = .white
        self.tintColor = ColorScheme.default.navTint
        self.shadowImage = UIImage(color: UIColor(white: 0.0, alpha: 0.15))
    }
}

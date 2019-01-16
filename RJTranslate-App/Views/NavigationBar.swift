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
        
        self.tintColor = ColorScheme.default.navTint
    }
}

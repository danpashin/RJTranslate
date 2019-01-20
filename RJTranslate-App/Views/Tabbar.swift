//
//  Tabbar.swift
//  RJTranslate-App
//
//  Created by Даниил on 20/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class Tabbar: UITabBar {
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        self.itemPositioning = .fill
        self.barTintColor = .white
        self.tintColor = ColorScheme.default.navTint
        self.clipsToBounds = true
        self.isTranslucent = false
        
        self.addShadow()
    }
    
    private func addShadow() {
        let shadowView = UIView()
        shadowView.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(shadowView)
        
        shadowView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        shadowView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        shadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}

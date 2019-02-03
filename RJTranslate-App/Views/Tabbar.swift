//
//  Tabbar.swift
//  RJTranslate-App
//
//  Created by Даниил on 20/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class Tabbar: UITabBar {
     let shadowView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.itemPositioning = .fill
        self.tintColor = ColorScheme.default.tabbarTint
        self.barTintColor = ColorScheme.default.tabbarBackground
        self.clipsToBounds = true
        self.isTranslucent = false
        
        self.addShadow()
    }
    
   private func addShadow() {
        self.shadowView.backgroundColor = ColorScheme.default.tabbarShadow
        self.shadowView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.shadowView)
        
        self.shadowView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        self.shadowView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.shadowView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.shadowView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    func hideShadow(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: { 
                self.shadowView.alpha = 0.0
            })
        } else {
            self.shadowView.alpha = 0.0
        }
    }
    
    func showShadow(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: { 
                self.shadowView.alpha = 1.0
            })
        } else {
            self.shadowView.alpha = 1.0
        }
    }
}

//
//  NavigationBar.swift
//  RJTranslate-App
//
//  Created by Даниил on 08/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class NavigationBar: UINavigationBar {
    private var defaultShadowImage: UIImage?
    private var shadowView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tintColor = ColorScheme.default.navTint
        self.barTintColor = ColorScheme.default.navBackground
        
        if #available(iOS 11.0, *) {
            self.defaultShadowImage = UIImage(color: UIColor(white: 0.0, alpha: 0.15))
            self.showShadow(animated: false)
        } else {
            self.rjt_hideShadow = true
            self.addCustomShadow()
        }
    }
    
    private func addCustomShadow() {
        self.shadowView = UIView()
        self.shadowView!.backgroundColor = ColorScheme.default.tabbarShadow
        self.shadowView!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.shadowView!)
        
        NSLayoutConstraint.activate([
            self.shadowView!.heightAnchor.constraint(equalToConstant: 1.0),
            self.shadowView!.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -1.0),
            self.shadowView!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.shadowView!.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            ])
    }
    
    func hideShadow(animated: Bool) {
        if #available(iOS 11.0, *) {
            self.shadowImage = UIImage()
        } else {
            if animated {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: { 
                    self.shadowView?.alpha = 0.0
                })
            } else {
                self.shadowView?.alpha = 0.0
            }
        }
    }
    
    func showShadow(animated: Bool) {
        if #available(iOS 11.0, *) {
            self.shadowImage = self.defaultShadowImage
        } else {
            if animated {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowAnimatedContent, .allowUserInteraction], animations: { 
                    self.shadowView?.alpha = 1.0
                })
            } else {
                self.shadowView?.alpha = 1.0
            }
        }
    }
}

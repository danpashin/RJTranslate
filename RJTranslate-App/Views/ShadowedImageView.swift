//
//  ShadowedImageView.swift
//  RJTranslate-App
//
//  Created by Даниил on 03/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class ShadowedImageView: UIImageView {
    
    override var image: UIImage? {
        willSet {
            self.updateShadow(for: newValue)
        }
    }
    
    private func updateShadow(for image: UIImage?) {
        if let averageColor = image?.averageColor {
            var red: CGFloat = 0.0
            var green: CGFloat = 0.0
            var blue: CGFloat = 0.0
            averageColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
            
            if red < 0.8 && green < 0.8 && blue < 0.8 {
                self.layer.shadowColor = averageColor.withAlphaComponent(0.6).cgColor
            } else {
                self.layer.shadowColor = UIColor(white: 0.0, alpha: 0.1).cgColor
            }
        }
        
        self.layer.shadowOpacity = 1.0
    }
}

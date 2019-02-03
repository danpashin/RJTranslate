//
//  GradientLayer.swift
//  RJTranslate-App
//
//  Created by Даниил on 12/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class GradientLayer: CAGradientLayer {
    
     override init() {
        super.init()
        
        self.colors = [
            ColorScheme.default.accentSecondary.cgColor,
            ColorScheme.default.accentMain.cgColor
        ]
        self.startPoint = CGPoint(x: 0.5, y: 0.0)
        self.endPoint = CGPoint(x: 0.5, y: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

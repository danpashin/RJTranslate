//
//  GradientImage.swift
//  RJTranslate-App
//
//  Created by Даниил on 13/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class GradientImage {
    
    public private(set) var normalState: UIImage?
    public private(set) var selectedState: UIImage?
    
    private var gradient: GradientView
    private var size: CGSize
    
    init(gradient: GradientView, size: CGSize) {
        self.gradient = gradient
        self.size = size
    }
    
    private func renderAllImages() {
        
    }
    
    private func renderImage(for state: UIControl.State) -> UIImage {
        
    }
}

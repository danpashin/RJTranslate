//
//  GradientView.swift
//  RJTranslate-App
//
//  Created by Даниил on 12/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class GradientView: UIView {
    
    override class var layerClass: AnyClass {
        return GradientLayer.self
    }
    
    override var layer: GradientLayer {
        return super.layer as! GradientLayer
    }
}

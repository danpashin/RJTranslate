//
//  GradientView.swift
//  RJTranslate-App
//
//  Created by Даниил on 12/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class GradientView: UIView {
    
    override public static var layerClass: AnyClass {
        return GradientLayer.self
    }
    
    override public var layer: GradientLayer {
        return super.layer as! GradientLayer
    }
}

//
//  GradientView.swift
//  RJTranslate-App
//
//  Created by Даниил on 12/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

@objc class GradientView: UIView {
    
    override public static var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    @objc override public var layer: CAGradientLayer {
        return super.layer as! CAGradientLayer
    }
    
    @objc(defaultGradientView) public static func `default`() -> GradientView {
        let gradientView = GradientView()
        gradientView.layer.colors = [RJTColors.accentSecondaryColor.cgColor, RJTColors.accentMainColor.cgColor]
        gradientView.layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientView.layer.endPoint = CGPoint(x: 0.5, y: 1.0)
    
        return gradientView
    }
}
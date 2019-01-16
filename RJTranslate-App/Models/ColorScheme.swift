//
//  ColorScheme.swift
//  RJTranslate-App
//
//  Created by Даниил on 16/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

@objc class ColorScheme: NSObject {
    
    @objc(defaultScheme) public static var `default`: ColorScheme = ColorScheme()
    
    
    /// Основной цвет приложения.
    @objc(accentMainColor) public let accentMain = UIColor.rgb(r: 95.0, g: 111.0, b: 237.0)
    
    /// Дополнительный цвет приложения.
    @objc(accentSecondaryColor) public let accentSecondary = UIColor.rgb(r: 117.0, g: 133.0, b: 220.0)
    
    /// Оттенок бара навигации.
    @objc(headerLabelColor) public let headerLabel = UIColor(white: 0.1, alpha: CGFloat(1.0))
    
    /// Цвет текста заголовков.
    @objc(navTintColor) public let navTint = UIColor.rgb(r: 95.0, g: 111.0, b: 237.0)
    
    /// Цвет основных подписей.
    @objc(textPrimaryColor) public let textPrimary = UIColor(white: 0.05, alpha: 1.0)
    
    /// Цвет детальных подписей.
    @objc(textDetailColor) public let textDetail = UIColor(white: 0.83, alpha: 1.0)
    
    /// Цвет текста заголовков.
    @objc(switchOnTintColor) public let switchOnTint = UIColor.rgb(r: 95.0, g: 111.0, b: 237.0)
}

fileprivate extension UIColor {
    fileprivate static func rgb(r: Double, g: Double, b: Double, a: Double = 255.0) -> UIColor {
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(a / 255.0))
    }
}

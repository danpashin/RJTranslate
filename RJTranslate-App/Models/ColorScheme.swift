//
//  ColorScheme.swift
//  RJTranslate-App
//
//  Created by Даниил on 16/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

struct ColorScheme {
    
    public static let `default`: ColorScheme = ColorScheme()
    
    
    /// Основной цвет приложения.
    public private(set) var accentMain = UIColor(r: 95.0, g: 111.0, b: 237.0)
    
    /// Дополнительный цвет приложения.
    public private(set) var accentSecondary = UIColor(r: 117.0, g: 133.0, b: 220.0)
    
    /// Оттенок бара навигации.
    public private(set) var headerLabel = UIColor(white: 0.0, alpha: 1.0)
    
    /// Цвет текста заголовков.
    public private(set) var navTint = UIColor(r: 95.0, g: 111.0, b: 237.0)
    
    /// Цвет основных подписей.
    public private(set) var textPrimary = UIColor(white: 0.05, alpha: 1.0)
    
    public private(set) var textWhitePrimary = UIColor(white: 1.0, alpha: 1.0)
    
    public private(set) var textWhiteDetail = UIColor(white: 0.8, alpha: 1.0)
    
    /// Цвет детальных подписей.
    public private(set) var textDetail = UIColor(white: 0.75, alpha: 1.0)
    
    /// Цвет текста заголовков.
    public private(set) var switchOnTint = UIColor(r: 95.0, g: 111.0, b: 237.0)
    
    /// Цвет фона.
    public private(set) var background = UIColor(r: 240.0, g: 241.0, b: 244.0)
}

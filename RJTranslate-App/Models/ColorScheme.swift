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
    
    /// Стиль статус бара
    public let statusBarStyle = UIStatusBarStyle.default
    
    /// Основной цвет приложения.
    public let accentMain = UIColor(r: 95.0, g: 111.0, b: 237.0)
    
    /// Дополнительный цвет приложения.
    public let accentSecondary = UIColor(r: 117.0, g: 133.0, b: 220.0)
    
    /// Оттенок бара навигации.
    public let navTint = UIColor(r: 95.0, g: 111.0, b: 237.0)
    
    /// Фон бара навигации.
    public let navBackground = UIColor(r: 255.0, g: 255.0, b: 255.0)
    
    /// Оттенок таббара.
    public let tabbarTint = UIColor(r: 95.0, g: 111.0, b: 237.0)
    
    /// Фон таббара.
    public let tabbarBackground = UIColor(r: 255.0, g: 255.0, b: 255.0)
    
    /// Цвет тени таббара.
    public let tabbarShadow = UIColor(r: 0.0, g: 0.0, b: 0.0, a: 25.5)
    
    
    
    /// Цвет текста заголовков.
    public let titleLabel = UIColor(r: 0.0, g: 0.0, b: 0.0)
    
    /// Цвет текста подзаголовков.
    public let subtitleLabel = UIColor(r: 180.0, g: 180.0, b: 180.0)
    
    /// Цвет градиентных кнопок в обычном состоянии.
    public let gradientButtonTitleNormal = UIColor(r: 255.0, g: 255.0, b: 255.0)
    
    /// Цвет градиентных кнопок в нажатом состоянии.
    public let gradientButtonTitleSelected = UIColor(r: 230.0, g: 230.0, b: 230.0)
    
    /// Цвет текста заголовков.
    public let switchOnTint = UIColor(r: 95.0, g: 111.0, b: 237.0)
    
    /// Цвет фона.
    public let background = UIColor(r: 240.0, g: 241.0, b: 244.0)
}

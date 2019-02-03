//
//  ColorScheme.swift
//  RJTranslate-App
//
//  Created by Даниил on 16/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

struct ColorScheme {
    
     static let `default`: ColorScheme = ColorScheme()
    
    /// Стиль статус бара
     let statusBarStyle = UIStatusBarStyle.default
    
    /// Основной цвет приложения.
     let accentMain = UIColor(r: 95.0, g: 111.0, b: 237.0)
    
    /// Дополнительный цвет приложения.
     let accentSecondary = UIColor(r: 117.0, g: 133.0, b: 220.0)
    
    /// Оттенок бара навигации.
     let navTint = UIColor(r: 95.0, g: 111.0, b: 237.0)
    
    /// Фон бара навигации.
     let navBackground = UIColor(r: 255.0, g: 255.0, b: 255.0)
    
    /// Оттенок таббара.
     let tabbarTint = UIColor(r: 95.0, g: 111.0, b: 237.0)
    
    /// Фон таббара.
     let tabbarBackground = UIColor(r: 255.0, g: 255.0, b: 255.0)
    
    /// Цвет тени таббара.
     let tabbarShadow = UIColor(r: 0.0, g: 0.0, b: 0.0, a: 25.5)
    
    
    
    /// Цвет разделителя.
     let separator = UIColor(r: 0.0, g: 0.0, b: 0.0, a: 25.5)
    
    
    
    /// Цвет текста заголовков.
     let titleLabel = UIColor(r: 0.0, g: 0.0, b: 0.0)
    
    /// Цвет текста подзаголовков.
     let subtitleLabel = UIColor(r: 180.0, g: 180.0, b: 180.0)
    
    /// Цвет кнопок в обычном состоянии.
     let buttonTitle = UIColor(r: 95.0, g: 111.0, b: 237.0)
    
    /// Цвет опасных кнопок в обычном состоянии.
    let buttonDestructiveTitle = UIColor(r: 255, g: 0.0, b: 0.0)
    
    /// Цвет градиентных кнопок в обычном состоянии.
     let gradientButtonTitleNormal = UIColor(r: 255.0, g: 255.0, b: 255.0)
    
    /// Цвет градиентных кнопок в нажатом состоянии.
     let gradientButtonTitleSelected = UIColor(r: 230.0, g: 230.0, b: 230.0)
    
    /// Цвет текста заголовков.
     let switchOnTint = UIColor(r: 95.0, g: 111.0, b: 237.0)
    
    /// Цвет фона.
     let background = UIColor(r: 240.0, g: 241.0, b: 244.0)
}

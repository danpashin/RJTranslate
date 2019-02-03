//
//  UIColorConveniences.swift
//  RJTranslate-App
//
//  Created by Даниил on 16/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation
import UIKit

/// Выполняет сравнение чисел типа CGFloat
///
/// - Parameters:
///   - a: первое число
///   - b: второе число
/// - Returns: Возвращает большее число из двух
 func MAX(a: CGFloat, b: CGFloat) -> CGFloat {
    return (a > b) ? a : b
}

extension UIColor {
    
    /// Выполняет изменение цвета на более темный.
    var darker: UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            red = MAX(a: red - 0.2, b: 0.0)
            green = MAX(a: green - 0.2, b: 0.0)
            blue = MAX(a: blue - 0.2, b: 0.0)
            
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
        
        return self
    }
    
    /// Создает цвет из указанных значений RGB.
    ///
    /// - Parameters:
    ///   - r: Значение красного в пределах от 0 до 255.
    ///   - g: Значение зеленого в пределах от 0 до 255.
    ///   - b: Значение синего в пределах от 0 до 255.
    ///   - a: Значение прозрачности в пределах от 0 до 255.
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 255.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a / 255.0)
    }
}

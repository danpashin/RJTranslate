//
//  UIImageConveniences.swift
//  RJTranslate-App
//
//  Created by Даниил on 20/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

public extension UIImage {
    
    /// Создает изображение с нужным цветом и размером.
    ///
    /// - Parameters:
    ///   - color: Цвет для изображения. Может иметь прозрачность.
    ///   - size: Размер полотна. По умолчанию, {1;1}
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) {
        var alpha: CGFloat = 1.0
        color.getRed(nil, green: nil, blue: nil, alpha: &alpha)
        
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        color.setFill()
        
        let contextRect = CGRect(origin: .zero, size: size)
        UIRectFill(contextRect)
        
        var image = UIGraphicsGetImageFromCurrentImageContext()
        
        if alpha < 1.0 {
            let context = UIGraphicsGetCurrentContext()
            context?.clear(contextRect)
            
            image?.draw(at: .zero, blendMode: .normal, alpha: alpha)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
        
    }
}

//
//  GradientImage.swift
//  RJTranslate-App
//
//  Created by Даниил on 13/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

@objc protocol GradientImageRendererDelegate : NSObjectProtocol {
    func renderer(_ renderer: GradientImageRenderer, didEndRenderingNormalImage normalImage: UIImage?, selectedImage: UIImage?)
}

@objc class GradientImageRenderer : NSObject {
    
    /// Скругление углов отрендеренного изображения. По умолчанию, 10.
    @objc public let cornerRadius: CGFloat = 10.0
    
    /// Изображение для нормального состояния.
    @objc public private(set) var normalImage: UIImage?
    
    /// Изображение для выбранного состояния.
    @objc public private(set) var selectedImage: UIImage?
    
    @objc public weak var delegate: GradientImageRendererDelegate?
    
    private var gradient: GradientView
    private var selectedGradient: GradientView
    
    /// Размеры изображения для рендеринга.
    private var size: CGSize
    
    @objc(rendering) public private(set) var isRendering = false
    
    private let renderingQueue = DispatchQueue(label: "ru.danpashin.rjtranslate.image.rendering", qos: .utility)
    
    @objc public init(size: CGSize) {
        self.size = size
        
        self.gradient = GradientView.default()
        self.selectedGradient = GradientView.default()
        self.selectedGradient.layer.colors = [
            ColorScheme.default.accentSecondaryColor.darker.cgColor,
            ColorScheme.default.accentMainColor.darker.cgColor
        ]
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMemoryWarning), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    @objc private func didReceiveMemoryWarning() {
        self.normalImage = nil
        self.selectedImage = nil
    }
    
    /// Выполняет рендеринг всех типов изображений в фоновом режиме. Вызывает делегат по окончании.
    @objc public func renderAllImages() {
        self.isRendering = true
        
        let group = DispatchGroup()
        
        self.renderingQueue.async(group: group) {
            self.normalImage = self.renderImage(from: self.gradient)
        }
        
        self.renderingQueue.async(group: group) {
            self.selectedImage = self.renderImage(from: self.selectedGradient)
        }
        
        group.notify(queue: .main) {
            self.isRendering = false
            
            self.delegate?.renderer(self, didEndRenderingNormalImage: self.normalImage, selectedImage: self.selectedImage)
        }
    }
    
    /// Выполняет рендеринг градиента в изображение.
    ///
    /// - Parameter gradient: Градиент для рендерингра.
    /// - Returns: Возвращает изображение либо nil, если рендеринг не удался.
    private func renderImage(from gradient: GradientView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        gradient.frame = CGRect(origin: CGPoint.zero, size: self.size)
        gradient.layer.cornerRadius = self.cornerRadius
        
        gradient.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

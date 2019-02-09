//
//  GradientImageRenderer.swift
//  RJTranslate-App
//
//  Created by Даниил on 13/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

protocol GradientImageRendererDelegate : AnyObject {
    func renderer(_ renderer: GradientImageRenderer,
                  didEndRenderingNormalImage normalImage: UIImage?, selectedImage: UIImage?)
}

class GradientImageRenderer {
    
    /// Скругление углов отрендеренного изображения. По умолчанию, 10.
    let cornerRadius: CGFloat = 10.0
    
    /// Изображение для нормального состояния.
    private(set) var normalImage: UIImage?
    
    /// Изображение для выбранного состояния.
    private(set) var selectedImage: UIImage?
    
    weak var delegate: GradientImageRendererDelegate?
    
    private var gradient: GradientLayer
    private var selectedGradient: GradientLayer
    
    /// Размеры изображения для рендеринга.
    private var size: CGSize
    
    private(set) var isRendering = false
    
    private let renderingQueue = DispatchQueue(label: "ru.danpashin.rjtranslate.image.rendering", qos: .utility)
    
    init(size: CGSize) {
        self.size = size
        
        let frame = CGRect(origin: CGPoint.zero, size: size)
        
        self.gradient = GradientLayer()
        self.gradient.frame = frame
        
        self.selectedGradient = GradientLayer()
        self.selectedGradient.frame = frame
        self.selectedGradient.colors = [
            ColorScheme.default.accentSecondary.darker.cgColor,
            ColorScheme.default.accentMain.darker.cgColor
        ]
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveMemoryWarning),
                                               name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func didReceiveMemoryWarning() {
        self.normalImage = nil
        self.selectedImage = nil
    }
    
    /// Выполняет рендеринг всех типов изображений в фоновом режиме. Вызывает делегат по окончании.
    func renderAllImages() {
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
    /// - Parameter gradient: Градиент для рендеринга.
    /// - Returns: Возвращает изображение либо nil, если рендеринг не удался.
    private func renderImage(from gradient: GradientLayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        gradient.cornerRadius = self.cornerRadius
        
        gradient.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

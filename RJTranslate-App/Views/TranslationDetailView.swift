//
//  TranslationDetailView.swift
//  RJTranslate-App
//
//  Created by Даниил on 27/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

/// Используется для отображения детальной информации о переводе.
class TranslationDetailView: UIView, GradientImageRendererDelegate {
    
    /// Лейбл с названием перевода.
    public let titleLabel = UILabel()
    
    /// Вид с иконкой приложения.
    public let iconView = UIImageView()
    
    /// Кнопка для установки перевода.
    public let installButton = UIButton()
    
    private var gradientRenderer: GradientImageRenderer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.iconView.layer.shadowRadius = 26.0
        self.iconView.layer.shadowOpacity = 0.1
        self.iconView.layer.shadowOffset = .zero
        self.addSubview(self.iconView)
        
        self.titleLabel.font = UIFont.systemFont(ofSize: UIFont.labelFontSize * 1.75, weight: .bold)
        self.addSubview(self.titleLabel)
        
//        self.installButton.backgroundColor = .red
//        self.installButton.layer.cor
        
        self.installButton.setTitleColor(ColorScheme.default.textWhitePrimary, for: .normal)
        self.installButton.setTitleColor(ColorScheme.default.textWhiteDetail, for: .selected)
        self.installButton.setTitle(NSLocalizedString("Translation.Install", comment: ""), for: .normal)
        
        self.addSubview(self.installButton)
        
        self.setupConstraints()
        
        DispatchQueue.main.async {
            self.gradientRenderer = GradientImageRenderer(size: CGSize(width: 320.0, height: 64.0))
            self.gradientRenderer?.delegate = self
            self.gradientRenderer?.renderAllImages()
        }
    }
    
    private func setupConstraints() {  
        self.iconView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.installButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.iconView.topAnchor.constraint(equalTo: self.topAnchor, constant: 26.0),
            self.iconView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.iconView.widthAnchor.constraint(equalToConstant: 76.0),
            self.iconView.heightAnchor.constraint(equalToConstant: 76.0),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.iconView.bottomAnchor, constant: 24.0),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0.0),
            self.titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0.0),
            
            self.installButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -36.0),
            self.installButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            self.installButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            self.installButton.heightAnchor.constraint(equalToConstant: 64.0)
            ])
    }
    
    func renderer(_ renderer: GradientImageRenderer, didEndRenderingNormalImage normalImage: UIImage?, selectedImage: UIImage?) {
        self.installButton.setBackgroundImage(normalImage, for: .normal)
        self.installButton.setBackgroundImage(selectedImage, for: .selected)
    }
}

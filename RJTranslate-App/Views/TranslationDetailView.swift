//
//  TranslationDetailView.swift
//  RJTranslate-App
//
//  Created by Даниил on 27/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

protocol TranslationDetailViewDelegate:class {
    func detailViewRequestedDownloadingTranslation(_ detailView: TranslationDetailView)
}

/// Используется для отображения детальной информации о переводе.
class TranslationDetailView: UIView, GradientImageRendererDelegate {
    
    /// Лейбл с названием перевода.
    let titleLabel = UILabel()
    
    let subtitleLabel = UILabel()
    
    /// Вид с иконкой приложения.
    let iconView = ShadowedImageView()
    
    /// Кнопка для установки перевода.
    let installButton = UIButton()
    
    private var gradientRenderer: GradientImageRenderer?
    
    weak var delegate: TranslationDetailViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    deinit {
        self.installButton.removeObserver(self, forKeyPath: "bounds")
    }
    
    private func commonInit() {
        self.iconView.layer.shadowRadius = 24.0
        self.iconView.layer.shadowOpacity = 0.0
        self.iconView.layer.shadowOffset = .zero
        self.addSubview(self.iconView)
        
        self.titleLabel.font = UIFont.systemFont(ofSize: UIFont.labelFontSize * 1.75, weight: .bold)
        self.addSubview(self.titleLabel)
        
        self.subtitleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        self.subtitleLabel.textColor = ColorScheme.default.subtitleLabel
        self.addSubview(self.subtitleLabel)
        
        self.installButton.addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
        self.installButton.setTitleColor(ColorScheme.default.gradientButtonTitleNormal, for: .normal)
        self.installButton.setTitleColor(ColorScheme.default.gradientButtonTitleSelected, for: .selected)
        self.installButton.setTitle(NSLocalizedString("Translation.Install", comment: ""), for: .normal)
        self.installButton.addTarget(self, action: #selector(self.installButtonTappped), for: .touchUpInside)
        self.addSubview(self.installButton)
        
        self.setupConstraints()
    }
    
    @objc func installButtonTappped() {
        self.delegate?.detailViewRequestedDownloadingTranslation(self)
    }
    
    private func setupConstraints() {  
        self.iconView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.installButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.iconView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30.0),
            self.iconView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.iconView.widthAnchor.constraint(equalToConstant: 76.0),
            self.iconView.heightAnchor.constraint(equalToConstant: 76.0),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.iconView.bottomAnchor, constant: 24.0),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0.0),
            self.titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0.0),
            
            self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16.0),
            self.subtitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.subtitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0.0),
            self.subtitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0.0),
            
            self.installButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -36.0),
            self.installButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            self.installButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            self.installButton.heightAnchor.constraint(equalToConstant: 64.0)
            ])
    }
    
    private func renderButtonBackground() {
        DispatchQueue.main.async {
            self.gradientRenderer = GradientImageRenderer(size: self.installButton.bounds.size)
            self.gradientRenderer?.delegate = self
            self.gradientRenderer?.renderAllImages()
        }
    }
    
    func renderer(_ renderer: GradientImageRenderer, didEndRenderingNormalImage normalImage: UIImage?, selectedImage: UIImage?) {
        self.installButton.setBackgroundImage(normalImage, for: .normal)
        self.installButton.setBackgroundImage(selectedImage, for: .selected)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let button = object as? UIButton, button == self.installButton, keyPath == "bounds" {
            self.renderButtonBackground()
        }
    }
}

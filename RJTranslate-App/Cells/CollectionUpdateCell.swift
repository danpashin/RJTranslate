//
//  CollectionUpdateCell.swift
//  RJTranslate-App
//
//  Created by Даниил on 01/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

@objc(RJTCollectionViewUpdateCell) public class CollectionUpdateCell: UICollectionViewCell {
    
    /// Основной лейбл хэдера.
    @objc public private(set) var textLabel: UILabel = UILabel.init()
    
    /// Дополнительный лейбл.
    @objc public private(set) var detailedTextLabel: UILabel = UILabel.init()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 8.0
        
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
        detailedTextLabel.textColor = UIColor.white
        detailedTextLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        
        let stackView = UIStackView.init(arrangedSubviews: [textLabel, detailedTextLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8.0
        self.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let gradientView = RJTGradientView.default
        self.insertSubview(gradientView, at: 0)
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view": gradientView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view": gradientView]))
    }
}

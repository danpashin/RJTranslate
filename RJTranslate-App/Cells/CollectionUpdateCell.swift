//
//  CollectionUpdateCell.swift
//  RJTranslate-App
//
//  Created by Даниил on 01/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

class CollectionUpdateCell: UICollectionViewCell {
    
    /// Основной лейбл хэдера.
    private(set) var textLabel = UILabel()
    
    /// Дополнительный лейбл.
    private(set) var detailedTextLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 8.0
        
        self.textLabel.textColor = UIColor.white
        self.textLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
        self.detailedTextLabel.textColor = UIColor.white
        self.detailedTextLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        
        let stackView = UIStackView(arrangedSubviews: [self.textLabel, self.detailedTextLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8.0
        self.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        let gradientView = GradientView()
        self.insertSubview(gradientView, at: 0)
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view": gradientView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view": gradientView]))
    }
}

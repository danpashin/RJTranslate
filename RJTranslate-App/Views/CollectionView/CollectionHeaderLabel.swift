//
//  CollectionHeaderLabel.swift
//  RJTranslate-App
//
//  Created by Даниил on 24/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

class CollectionHeaderLabel : UICollectionReusableView {
    
    /// Текст лейбла.
    var text: String? {
        didSet {
            self.label.text = text
            self.separatorView.isHidden = (text?.count ?? 0 > 0)
        }
    }
    
    private var separatorView: UIView = UIView()
    private var label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.label)
        self.label.textColor = ColorScheme.default.titleLabel
        self.label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize,
                                            weight: .semibold)
        
        self.addSubview(self.separatorView)
        self.separatorView.backgroundColor = ColorScheme.default.separator
        
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.separatorView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        self.separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1.0).isActive = true
        self.separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0).isActive = true
        self.separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0).isActive = true
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.leadingAnchor.constraint(equalTo: self.separatorView.leadingAnchor).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.separatorView.topAnchor).isActive = true
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.text = nil
    }
    
}

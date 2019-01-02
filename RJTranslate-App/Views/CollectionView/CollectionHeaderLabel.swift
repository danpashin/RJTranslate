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
    public var text: String? {
        didSet {
            self.label.text = text
            self.separatorView.isHidden = (text?.count ?? 0 > 0)
        }
    }
    
    private var separatorView: UIView = UIView()
    private var label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.label.textColor = RJTColors.headerColor
        self.label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize + 4.0,
                                            weight: .bold)
        
        self.separatorView.layer.cornerRadius = 1.5
        self.separatorView.backgroundColor = UIColor(red: 228/255.0, green: 228/255.0, blue: 230/255.0, alpha: 1.0)
        
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.separatorView.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
        self.separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3.0).isActive = true
        self.separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0).isActive = true
        self.separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0).isActive = true
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.leadingAnchor.constraint(equalTo: self.separatorView.leadingAnchor).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.separatorView.topAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.text = nil
    }
    
}

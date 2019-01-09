//
//  ButtonedSearchBar.swift
//  RJTranslate-App
//
//  Created by Даниил on 08/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

@objc public class ButtonedSearchBar: UIView {
    
    public weak var delegate: UISearchBarDelegate?
    
    private let stackView: UIStackView = UIStackView()
    private let searchBar: UISearchBar = UISearchBar()
    private let cancelButton: UIButton = UIButton()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.layer.cornerRadius = 10.0
        
        self.stackView.frame = self.bounds
        
        self.searchBar.frame = self.bounds
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.autoresizingMask = self.autoresizingMask
        self.addSubview(self.searchBar)
    }
    
}

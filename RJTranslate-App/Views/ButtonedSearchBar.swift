//
//  ButtonedSearchBar.swift
//  RJTranslate-App
//
//  Created by Даниил on 08/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class ButtonedSearchBar: UIView {
    
    public weak var delegate: UISearchBarDelegate? {
        didSet {
            self.searchBar.delegate = self.delegate
        }
    }
    
    public var showCancelButton = false {
        didSet {
            UIView.animate(withDuration: 0.50, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: [], animations: {
                self.cancelButton.isHidden = !self.showCancelButton
            }, completion: nil)
        }
    }
    
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
        self.stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.stackView.axis = .horizontal
        self.stackView.spacing = 8.0
        self.stackView.frame = self.bounds
        self.addSubview(self.stackView)
        
        self.searchBar.layer.cornerRadius = 16.0
        self.searchBar.layer.masksToBounds = true
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.placeholder = NSLocalizedString("search", comment: "Search bar placeholder")
        self.stackView.addArrangedSubview(self.searchBar)
        
        self.cancelButton.isHidden = true
        self.cancelButton.setTitle(NSLocalizedString("cancel", comment: "Cancel search"), for: .normal)
        self.cancelButton.addTarget(self, action: #selector(endSearch), for: .touchUpInside)
        self.stackView.addArrangedSubview(self.cancelButton)
    }
    
    override public func tintColorDidChange() {
        super.tintColorDidChange()
        
        self.cancelButton.setTitleColor(self.tintColor, for: .normal)
    }
    
    @objc public func endSearch() {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.delegate?.searchBarCancelButtonClicked?(self.searchBar)
    }
    
}

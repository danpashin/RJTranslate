//
//  SearchResultCell.swift
//  RJTranslate-App
//
//  Created by Даниил on 23/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

public class SearchResultCell: UITableViewCell {
    
    /// Результат поиска локализации.
    public var result: API.TranslationSummary? {
        didSet {
            self.updateName()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    private func commonInit() {
        self.imageView?.image = UIImage(named: "search_normal_20")?.withRenderingMode(.alwaysTemplate)
        self.imageView?.tintColor = .lightGray
        
        self.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        self.textLabel?.text = nil
    }
    
    private func updateName() {
        if self.result != nil {
            let defaultAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            let attributedText = NSMutableAttributedString(string: result!.name, attributes: defaultAttributes)
            
            if let range = result!.name.lowercased().range(of: result!.searchText.lowercased()) {
                attributedText.addAttribute(NSAttributedString.Key.foregroundColor, 
                                            value: ColorScheme.default.textPrimary, 
                                            range: NSRange(range, in: result!.name))
            }
            self.textLabel?.attributedText = attributedText
        } else {
            self.textLabel?.text = nil
        }
    }
}

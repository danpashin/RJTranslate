//
//  SearchResultsTableView.swift
//  RJTranslate-App
//
//  Created by Даниил on 22/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

public class SearchResultsTableView: UITableView {
    
    public let model = SearchResultsTableModel()
    private let emptySource = SearchResultsEmptySource()
    
    public var isRefreshing = false {
        didSet {
            self.reloadData()
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.model.tableView = self
        self.emptySource.tableView = self
        self.tableFooterView = UIView()
        
        self.keyboardDismissMode = .onDrag
        self.backgroundColor = ColorScheme.default.background
    }
    
    override public func reloadData() {
        DispatchQueue.main.async {
            super.reloadData()
        }
    }
}

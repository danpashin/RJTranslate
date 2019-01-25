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
    
    private let refreshHeader = UIActivityIndicatorView()
    
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
        
        self.refreshHeader.frame = self.refreshHeader.frame.insetBy(dx: 0.0, dy: -20.0)
        self.refreshHeader.style = .gray
        
        self.tableFooterView = UIView()
        
        self.keyboardDismissMode = .onDrag
        self.backgroundColor = ColorScheme.default.background
    }
    
    public func startRefreshing() {
        DispatchQueue.main.async {
            self.tableHeaderView = self.refreshHeader
            self.refreshHeader.startAnimating()
        }
    }
    
    public func stopRefreshing() {
        DispatchQueue.main.async {
            self.refreshHeader.stopAnimating()
            self.tableHeaderView = nil
        }
    }
    
    override public func reloadData() {
        DispatchQueue.main.async {
            super.reloadData()
        }
    }
}

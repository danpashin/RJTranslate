//
//  PreferencesController.swift
//  RJTranslate-App
//
//  Created by Даниил on 01/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

class PreferencesController: UITableViewController, PrefsTableModelDelegate {
    
    /// Класс модели для инициализации.
    class var modelClass: PreferencesTableModel.Type {
        return PreferencesTableModel.self
    }
    
    /// Модель настроек
    private var model: PreferencesTableModel!
    
    override init(style: UITableView.Style) {
        super.init(style: .grouped)
        self.commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        let cls = type(of: self).modelClass
        self.model = cls.init(delegate: self)
        self.model.parentController = self
    }
    
    override func loadView() {
        super.loadView()
        
        self.tableView.delegate = self.model
        self.tableView.dataSource = self.model
        self.tableView.allowsSelection = true
        self.tableView.backgroundColor = ColorScheme.default.background
    }
    
    // MARK: -
    // MARK: PrefsTableModelDelegate
    
    func didSetPreferenceValue(_ value: AnyHashable?, forKey key: String) {
        
    }
}

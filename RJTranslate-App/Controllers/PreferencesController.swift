//
//  PreferencesController.swift
//  RJTranslate-App
//
//  Created by Даниил on 01/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

class PreferencesController: UITableViewController, PrefsTableModelDelegate {
    
    /// Модель таблицы
    private var model: PreferencesTableModel?
    
    override init(style: UITableView.Style) {
        super.init(style: .grouped)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        super.loadView()
        
        self.model = PreferencesTableModel(tableView: self.tableView, delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Preferences.Title", comment: "")
    }
    
    
    // MARK: -
    // MARK: PrefsTableModelDelegate
    
    func userDidSetPreferenceValue(_ value: AnyHashable?, forKey key: String) {
        
        if key == "send_statistics" {
            let enabled: Bool = (value as? NSNumber)?.boolValue ?? true
            UIApplication.applicationDelegate.enableTracker(enabled)
        }
    }
}

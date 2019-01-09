//
//  PreferencesController.swift
//  RJTranslate-App
//
//  Created by Даниил on 01/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

@objc(RJTPreferencesController) class PreferencesController: UITableViewController, PrefsTableModelDelegate {
    
    /// Модель таблицы
    private var model: PreferencesTableModel?
    
    override init(style: UITableView.Style) {
        super.init(style: .grouped)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(style:) instead")
    }
    
    override func loadView() {
        super.loadView()
        
        model = PreferencesTableModel(tableView: self.tableView, delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("preferences", comment: "")
    }
    
    
    // MARK: - PrefsTableModelDelegate -
    
    func userDidSetPreferenceValue(_ value: Any?, forKey key: String) {
        let delegate = UIApplication.shared.appDelegate
        
        if key == "send_statistics" {
            let enabled: Bool = (value as? NSNumber)?.boolValue ?? true
            delegate.enableTracker(enabled)
        }
    }
}

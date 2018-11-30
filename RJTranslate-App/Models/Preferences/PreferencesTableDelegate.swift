//
//  PreferencesModel.swift
//  RJTranslate-App
//
//  Created by Даниил on 30/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

@objc protocol PrefsTableModelDelegate {
    func userDidSetPreferenceValue(_ value: Any?, forKey key: String)
}

@objc(RJTPrefsTableModel) class PreferencesTableModel : NSObject, UITableViewDelegate, UITableViewDataSource {
    private weak var tableView: UITableView?
    public private(set) weak var delegate: PrefsTableModelDelegate?
    
    private var groups: [PreferenceGroup] = []
    
    @objc public init(tableView: UITableView, delegate: PrefsTableModelDelegate) {
        self.tableView = tableView
        self.delegate = delegate
        
        super.init()
        
        createPreferences()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func createPreferences() {
        let sendStatsPrefs = SwitchPreference.init(key: "send_statistics", defaultValue: NSNumber(value: true),
                                                   title: NSLocalizedString("send_statistics", comment: ""))
        
        let sendCrashPrefs = SwitchPreference.init(key: "send_crashlogs", defaultValue: NSNumber(value: true),
                                                   title: NSLocalizedString("send_statistics", comment: ""))
        
        groups = [
            createGroup(title: "statistics", footer: "send_statistics_footer",
                        preference: sendStatsPrefs as Preference),
            
            createGroup(title: nil, footer: "send_crashlogs_footer",
                        preference: sendCrashPrefs as Preference)
        ]
    }
    
    private func createGroup(title: String?, footer: String?, preference: Preference) -> PreferenceGroup {
        preference.prefsTableModel = self
        
        let localizedTitle = NSLocalizedString(title ?? "", comment: "")
        let localizedFooter = NSLocalizedString(footer ?? "", comment: "")
        
        return PreferenceGroup.init(title: localizedTitle, footerText: localizedFooter, preferences: [preference])
    }
    
    
    // MARK: -
    // MARK: delegates
    // MARK: -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups[section].preferences.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let preference = groups[indexPath.section].preferences[indexPath.row]
        
        var cell: UITableViewCell? = nil
        if preference.category == .Text {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "staticTextCell")
        } else if preference.category == .Switch {
            cell = SwitchCell.init(model: preference as! SwitchPreference, reuseIdentifier: "switchCell")
        }
        
        cell?.textLabel?.text = preference.title
        return cell ?? UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groups[section].title
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return groups[section].footerText
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

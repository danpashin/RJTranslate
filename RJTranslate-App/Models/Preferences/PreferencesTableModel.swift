//
//  PreferencesModel.swift
//  RJTranslate-App
//
//  Created by Даниил on 30/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

protocol PrefsTableModelDelegate: class {
    func userDidSetPreferenceValue(_ value: AnyHashable?, forKey key: String)
}

class PreferencesTableModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    private weak var tableView: UITableView?
    public private(set) weak var delegate: PrefsTableModelDelegate?
    
    private var groups: [PreferenceGroup] = []
    
    public init(tableView: UITableView, delegate: PrefsTableModelDelegate) {
        self.tableView = tableView
        self.delegate = delegate
        
        super.init()
        
        self.createPreferences()
        
        tableView.allowsSelection = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func createPreferences() {
        let sendStatsPrefs = SwitchPreference(key: "send_statistics", defaultValue: NSNumber(value: true),
                                              title: NSLocalizedString("send_statistics", comment: ""))
        
        let sendCrashPrefs = SwitchPreference(key: "send_crashlogs", defaultValue: NSNumber(value: true),
                                              title: NSLocalizedString("send_crashlogs", comment: ""))
        
        
        let purgeDatabase = ButtonPreference(title:NSLocalizedString("Settings.Database.Purge", comment: ""),
                                             target: UIApplication.applicationDelegate, 
                                             action: #selector(UIApplication.applicationDelegate.purgeDatabase), 
                                             style: .destructive)
        
        self.groups = [
            createGroup(title: "statistics", footer: "send_statistics_footer",
                        preference: sendStatsPrefs as Preference),
            
            createGroup(title: nil, footer: "send_crashlogs_footer",
                        preference: sendCrashPrefs as Preference),
            
            createGroup(title: nil, footer: nil, preference: purgeDatabase)
        ]
    }
    
    private func createGroup(title: String?, footer: String?, preference: Preference) -> PreferenceGroup {
        preference.prefsTableModel = self
        
        let localizedTitle = NSLocalizedString(title ?? "", comment: "")
        let localizedFooter = NSLocalizedString(footer ?? "", comment: "")
        
        return PreferenceGroup(title: localizedTitle, footerText: localizedFooter, preferences: [preference])
    }
    
    
    // MARK: -
    // MARK: delegates
    // MARK: -
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.groups.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups[section].preferences.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let preference = self.groups[indexPath.section].preferences[indexPath.row]
        
        var cell: UITableViewCell? = nil
        
        if preference.category == .text {
            cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        } else if preference.category == .switch {
            cell = PreferenceSwitchCell(model: preference as! SwitchPreference, reuseIdentifier: nil)
        } else if preference.category == .button {
            cell = PreferenceButttonCell(model: preference as! ButtonPreference, reuseIdentifier: nil)
        }
        
        if cell == nil { cell = UITableViewCell() }
        cell!.textLabel?.text = preference.title
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.groups[section].title
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return groups[section].footerText
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let preference = self.groups[indexPath.section].preferences[indexPath.row]
        if preference is ButtonPreference {
            return true
        }
        
        return false
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let preference = self.groups[indexPath.section].preferences[indexPath.row]
        
        if preference is ButtonPreference {
            let buttonPreference = preference as! ButtonPreference
            buttonPreference.invokeAction()
        }
    }
}

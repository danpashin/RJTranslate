//
//  PreferencesModel.swift
//  RJTranslate-App
//
//  Created by Даниил on 30/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

protocol PrefsTableModelDelegate:class {
    func userDidSetPreferenceValue(_ value: AnyHashable?, forKey key: String)
}

class PreferencesTableModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    private weak var tableView: UITableView?
    private(set) weak var delegate: PrefsTableModelDelegate?
    
    private var groups: [PreferenceGroup] = []
    
    init(tableView: UITableView, delegate: PrefsTableModelDelegate) {
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
                                              title: NSLocalizedString("Settings.Stats.Send", comment: ""))
        
        let sendCrashPrefs = SwitchPreference(key: "send_crashlogs", defaultValue: NSNumber(value: true),
                                              title: NSLocalizedString("Settings.Crashlogs.Send", comment: ""))
        
        self.groups = [
            createGroup(title: "Settings.Stats", footer: "Settings.Stats.Send.Footer",
                        preference: sendStatsPrefs as Preference),
            
            createGroup(title: nil, footer: "Settings.Crashlogs.Send.Footer",
                        preference: sendCrashPrefs as Preference)
        ]
        
        #if DEBUG
        let appDelegate = UIApplication.applicationDelegate
        let purgeDatabase = ButtonPreference(title:NSLocalizedString("Settings.Database.Purge", comment: ""),
                                             target: appDelegate,
                                             action: #selector(appDelegate.purgeDatabase),
                                             style: .destructive)
        let databaseGroup = createGroup(title: "Settings.Database", footer: nil, preference: purgeDatabase)
        self.groups.append(databaseGroup)
        #endif
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.groups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups[section].preferences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let preference = self.groups[indexPath.section].preferences[indexPath.row]
        
        var cell: UITableViewCell?
        
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.groups[section].title
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return groups[section].footerText
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let preference = self.groups[indexPath.section].preferences[indexPath.row]
        if preference is ButtonPreference {
            return true
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let preference = self.groups[indexPath.section].preferences[indexPath.row]
        
        if preference is ButtonPreference {
            let buttonPreference = preference as! ButtonPreference
            buttonPreference.invokeAction()
        }
    }
}

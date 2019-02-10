//
//  PreferencesModel.swift
//  RJTranslate-App
//
//  Created by Даниил on 30/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation

protocol PrefsTableModelDelegate:class {
    func didSetPreferenceValue(_ value: AnyHashable?, forKey key: String)
}

class PreferencesTableModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    unowned var parentController: UIViewController?
    
    private(set) unowned var delegate: PrefsTableModelDelegate!
    
    private var groups = [PreferenceGroup]()
    
    required init(delegate: PrefsTableModelDelegate) {
        super.init()
        
        self.delegate = delegate
        self.createPreferences()
    }
    
    func createPreferences() {
        
    }
    
    func createGroup(title: String?, footer: String?, preference: Preference) -> PreferenceGroup {
        preference.prefsTableModel = self
        
        let localizedTitle = NSLocalizedString(title ?? "", comment: "")
        let localizedFooter = NSLocalizedString(footer ?? "", comment: "")
        
        return PreferenceGroup(title: localizedTitle, footerText: localizedFooter, preferences: [preference])
    }
    
    func setPreferences(_ preferences: [PreferenceGroup]) {
        self.groups = preferences
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
        
        if preference.category == .titleValue {
            cell = PreferenceTitleValueCell(model: preference, reuseIdentifier: nil)
        } else if preference.category == .switch {
            cell = PreferenceSwitchCell(model: preference, reuseIdentifier: nil)
        } else if preference.category == .button {
            cell = PreferenceButttonCell(model: preference, reuseIdentifier: nil)
        } else if preference.category == .detailLink {
            cell = PreferenceDetailLinkCell(model: preference, reuseIdentifier: nil)
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
        } else if preference is DetailLinkPreference {
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
        } else if preference is DetailLinkPreference {
            let detailPreference = preference as! DetailLinkPreference
            let detailController = detailPreference.createController()
            
            let navigationController = self.parentController?.navigationController
            navigationController?.pushViewController(detailController, animated: true)
        }
    }
}

//
//  PreferencesMainModel.swift
//  RJTranslate-App
//
//  Created by Даниил on 10/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class PreferencesMainModel: PreferencesTableModel {
    override func createPreferences() {
        let sendStatsPref = SwitchPreference(key: "send_statistics", defaultValue: true as NSNumber,
                                             title: NSLocalizedString("Settings.Stats.Send", comment: ""))
        
        let sendCrashPref = SwitchPreference(key: "send_crashlogs", defaultValue: true as NSNumber,
                                             title: NSLocalizedString("Settings.Crashlogs.Send", comment: ""))
        
        
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        let versionPref = TitleValuePreference(title: NSLocalizedString("Settings.AppInfo.Version", comment: ""),
                                               value: version as? String)
        
        let buildPref = TitleValuePreference(title: NSLocalizedString("Settings.AppInfo.Build", comment: ""),
                                               value: self.getBuildDate())
        let localizedBuildInfoTitle = NSLocalizedString("Settings.AppInfo.Title", comment: "")
        
        var preferences = [
            self.createGroup(title: "Settings.Stats", footer: "Settings.Stats.Send.Footer",
                             preference: sendStatsPref as Preference),
            
            self.createGroup(title: nil, footer: "Settings.Crashlogs.Send.Footer",
                             preference: sendCrashPref as Preference),
            
            PreferenceGroup(title: nil, footerText: nil, preferences: []),
            
            PreferenceGroup(title: localizedBuildInfoTitle,
                            footerText: nil, preferences: [versionPref, buildPref])
        ]
        
        #if DEBUG
        let debugPrefs = DetailLinkPreference(title: "Debug settings", detail: PreferencesDebugController.self)
        let debugGroup = self.createGroup(title: nil, footer: nil, preference: debugPrefs as Preference)
        preferences.append(debugGroup)
        #endif
        
        self.setPreferences(preferences)
    }
    
    private func getBuildDate() -> String? {
        guard let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
            else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddHHmm"
        guard let date = dateFormatter.date(from: build) else { return nil }
        
        return DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .short)
    }
}

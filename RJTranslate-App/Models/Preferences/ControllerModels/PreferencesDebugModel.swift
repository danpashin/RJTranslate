//
//  PreferencesDebugModel.swift
//  RJTranslate-App
//
//  Created by Даниил on 10/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//
#if DEBUG

import Foundation
import Crashlytics

class PreferencesDebugModel: PreferencesTableModel {
    
    override func createPreferences() {
        let purgeDatabase = ButtonPreference(title: "Purge database",
                                             target: self,
                                             action: #selector(self.purgeDatabase),
                                             style: .destructive)
        let databaseGroup = createGroup(title: "Database", footer: nil, preference: purgeDatabase)
        
        
        let crashButton = ButtonPreference(title: "CRAAAASH!",
                                             target: self,
                                             action: #selector(self.crash),
                                             style: .destructive)
        let crashGroup = createGroup(title: nil, footer: nil, preference: crashButton)
        
        self.setPreferences([databaseGroup, crashGroup])
    }
    
    @objc func purgeDatabase() {
        let database = UIApplication.applicationDelegate.defaultDatabase!
        database.purge {
            database.forceSaveContext()
            NotificationCenter.default.post(name: Notification.mainControllerReloadData, object: nil)
        }
    }
    
    @objc func crash() {
        Crashlytics.sharedInstance().crash()
    }
}
#endif

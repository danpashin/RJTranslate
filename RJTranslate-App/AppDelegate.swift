//
//  AppDelegate.swift
//  RJTranslate-App
//
//  Created by Даниил on 01/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CrashlyticsDelegate {
    
var window: UIWindow?
    
    /// Трекер событий приложения.
   private(set) var tracker: Tracker?
    
    /// Дефолтная база данных.
   private(set) var defaultDatabase: RJTDatabaseFacade?
    
    var tabbarController: TabbarController {
        return self.window!.rootViewController as! TabbarController
    }
    
    var currentNavigationController: NavigationController {
        return self.tabbarController.selectedViewController as! NavigationController
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.defaultDatabase = RJTDatabaseFacade()
        
        self.setupAnalytics()
        
        HTTPClientPinning.addTrustFor(domain: "rejail.ru", keyHash: "IGnfBrtoEP6+a09tVsEwYH15Qvjyt9r40Y5pYCvlIbg=")
        HTTPClientPinning.addTrustFor(domain: "api.rejail.ru", keyHash: "/7HcrFbhXchKnpl0XlNGwuOZmIVi53GOUnAYHACoD6s=")
        HTTPClientPinning.addTrustFor(domain: "translations.rejail.ru", keyHash: "NAZrOsLKtF5drHMC0mE3+6ncFGHBD9LHUCWsJ+TSgXE=")
        
        return true
    }
    
   private func setupAnalytics() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        Crashlytics.sharedInstance().delegate = self
        FirebaseApp.configure()
        
        let enableStatsPrefs = UserDefaults.standard.object(forKey: "send_statistics") as? NSNumber
        let enableStats = (enableStatsPrefs?.boolValue) ?? true
        self.enableTracker(enableStats)
    }
    
    func enableTracker(_ enable: Bool) {
        self.tracker = enable ? Tracker() : nil
        AnalyticsConfiguration.shared().setAnalyticsCollectionEnabled(enable)
    }
    
    @objc func purgeDatabase() {
        let database = UIApplication.applicationDelegate.defaultDatabase!
        database.purge { 
            database.forceSaveContext()
            NotificationCenter.default.post(name: Notification.mainControllerReloadData, object: nil)
        }
    }
    
    // MARK: -
    // MARK: CrashlyticsDelegate
    // MARK: -
    
    func crashlyticsDidDetectReport(forLastExecution report: CLSReport, completionHandler: @escaping (Bool) -> Void) {
        let sendReportsPrefs = UserDefaults.standard.object(forKey: "send_crashlogs") as? NSNumber
        let sendReports = (sendReportsPrefs?.boolValue) ?? true
        
        completionHandler(sendReports)
    }
}

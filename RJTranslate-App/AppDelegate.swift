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
public class AppDelegate: UIResponder, UIApplicationDelegate, CrashlyticsDelegate {
    
    public var window: UIWindow?
    
    /// Трекер событий приложения.
    public private(set) var tracker: Tracker?
    
    /// Дефолтная база данных.
    public private(set) var defaultDatabase: RJTDatabaseFacade?
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        Crashlytics.sharedInstance().delegate = self
        FirebaseApp.configure()
        
        let enableStatsPrefs = UserDefaults.standard.object(forKey: "send_statistics") as? NSNumber
        let enableStats = (enableStatsPrefs?.boolValue) ?? true
        self.enableTracker(enableStats)
        
        self.defaultDatabase = RJTDatabaseFacade()
        
        return true
    }
    
    public func enableTracker(_ enable: Bool) {
        self.tracker = enable ? Tracker() : nil
    
        AnalyticsConfiguration.shared().setAnalyticsCollectionEnabled(enable)
    }
    
    // MARK: -
    // MARK: CrashlyticsDelegate
    // MARK: -
    
    public func crashlyticsDidDetectReport(forLastExecution report: CLSReport, completionHandler: @escaping (Bool) -> Void) {
        let sendReportsPrefs = UserDefaults.standard.object(forKey: "send_crashlogs") as? NSNumber
        let sendReports = (sendReportsPrefs?.boolValue) ?? true
        
        completionHandler(sendReports)
    }
}

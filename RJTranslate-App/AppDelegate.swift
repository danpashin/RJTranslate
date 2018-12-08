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
@objc(RJTAppDelegate) public class AppDelegate: UIResponder, UIApplicationDelegate, CrashlyticsDelegate {
    
    @objc public var window: UIWindow?
    
    /// Трекер событий приложения.
    @objc public private(set) var tracker: Tracker?
    
    /// Дефолтная база данных.
    @objc public private(set) var defaultDatabase: RJTDatabase?
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        Crashlytics.sharedInstance().delegate = self
        FirebaseApp.configure()
        
        let enableStatsPrefs: NSNumber? = UserDefaults.standard.object(forKey: "send_statistics") as? NSNumber
        let enableStats: Bool = (enableStatsPrefs?.boolValue) ?? true
        self.enableTracker(enableStats)
        
        self.defaultDatabase = RJTDatabase.default()
        
        return true
    }
    
    public func enableTracker(_ enable: Bool) {
        tracker = enable ? Tracker.init() : nil
    
        AnalyticsConfiguration.shared().setAnalyticsCollectionEnabled(enable)
    }
    
//    - (void)flushCacheIfNeeded
//    {
//    [[RJTImageCache sharedCache] countSizeWithCompletion:^(NSUInteger cacheSize) {
//    if (cacheSize > 20 * 1024 * 1024)
//    [[RJTImageCache sharedCache] flush];
//    }];
//    }
    
    // MARK: -
    // MARK: CrashlyticsDelegate
    // MARK: -
    
    public func crashlyticsDidDetectReport(forLastExecution report: CLSReport, completionHandler: @escaping (Bool) -> Void) {
        let sendReportsPrefs: NSNumber? = UserDefaults.standard.object(forKey: "send_crashlogs") as? NSNumber
        let sendReports: Bool = (sendReportsPrefs?.boolValue) ?? true
        
        completionHandler(sendReports)
    }
}

@objc extension UIApplication {
    @objc public var appDelegate: AppDelegate {
        
        var delegateObject: AppDelegate?  = nil
        
        if Thread.isMainThread {
            delegateObject = self.delegate as? AppDelegate
        } else {
            DispatchQueue.main.sync {
                delegateObject = self.delegate as? AppDelegate
            }
        }
        
        return delegateObject!
    }
    
    @objc public class var applicationDelegate: AppDelegate {
        return UIApplication.shared.appDelegate
    }
}

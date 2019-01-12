//
//  ApplicationConviniences.swift
//  RJTranslate-App
//
//  Created by Даниил on 07/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation
import Firebase

@discardableResult
func appRecordError(_ description: String, _ args: CVarArg...) -> NSError {
    let errorDescription = String(format: description, args)
    let error = NSError(domain: "ru.danpashin.rjtranslate.error", code: -1, userInfo: [NSLocalizedDescriptionKey:errorDescription])
    
    NSLog(description, args)
    Crashlytics.sharedInstance().recordError(error)
    
    return error
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
    
    @objc public static var applicationDelegate: AppDelegate {
        return UIApplication.shared.appDelegate
    }
}
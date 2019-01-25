//
//  ApplicationConveniences.swift
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
//    Crashlytics.sharedInstance().recordError(error)
    
    return error
}


extension UIApplication {
    public var appDelegate: AppDelegate {
        
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
    
    public static var applicationDelegate: AppDelegate {
        return UIApplication.shared.appDelegate
    }
}

public func heapAddress(of object: AnyObject) -> String {
    return String(format: "%p", unsafeBitCast(object, to: Int.self))
}

public func className(of object: AnyObject) -> String {
    return String(describing: type(of: object))
}

public func classInfo(of object: AnyObject) -> String {
    let clsName = className(of: object)
    let address = heapAddress(of: object)
    return "\(clsName): \(address)"
}

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /// Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
    /// only execute the code once even in the presence of multithreaded calls.
    ///
    /// - Parameters:
    ///   - token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
    ///   - block: Block to execute once
    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}
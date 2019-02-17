//
//  NotificationConveniences.swift
//  RJTranslate-App
//
//  Created by Даниил on 11/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation


class PropertyObserver {
    private static var registeredNotifications = [Notification.Name: NSObjectProtocol]()
    
    enum PropertyObserverError: Error {
        case notificationAlreadyAdded
    }
    
    /// Имя для нотификации.
    var name: Notification.Name
    
    /// Старое значение проперти.
    var oldValue: Any?
    
    /// Новое значение проперти.
    var newValue: Any?
    
    init(name: Notification.Name, oldValue: Any?, newValue: Any?) {
        self.name = name
        self.oldValue = oldValue
        self.newValue = newValue
    }
    
    func post() {
        NotificationCenter.post(name: self.name, object: self)
    }
    
    class func observe(name: Notification.Name, handler: @escaping (PropertyObserver) -> Void) throws {
        if self.registeredNotifications.contains(where: { (key, _) -> Bool in return key == name }) {
            throw PropertyObserverError.notificationAlreadyAdded
        }
        
        let center = NotificationCenter.default
        let observer = center.addObserver(forName: name, object: nil, queue: .main) { (notification) in
            if let changeModel = notification.object as? PropertyObserver {
                handler(changeModel)
            }
        }
        
        self.registeredNotifications[name] = observer
    }
    
    static func removeObserve(name: Notification.Name) {
        self.registeredNotifications.removeValue(forKey: name)
    }
}

extension Notification.Name {
    
    /// Нотификация вызывается для анимированой перезагрузки
    /// коллекции переводов на главной странице
    static var translationCollectionReloadData: NSNotification.Name {
        return .init("rjtranslate.translCollectin.Reload")
    }
    
    static var translationCollectionLoadDatabase: NSNotification.Name {
        return .init("rjtranslate.translCollectin.Load.Database")
    }
    
    static var translationCollectionReloadNoAnim: NSNotification.Name {
        return .init("rjtranslate.translCollectin.ReloadIndexPaths")
    }
}

extension NotificationCenter {
    
    static func post(name: Notification.Name, object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object)
    }
    
    static func observe(name: NSNotification.Name?, object obj: Any? = nil, queue: OperationQueue? = .main, 
                        using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: name, object: obj, queue: queue, using: block)
    }
}

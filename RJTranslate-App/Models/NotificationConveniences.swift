//
//  NotificationConveniences.swift
//  RJTranslate-App
//
//  Created by Даниил on 11/02/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

struct PropertyObserver {
    
    /// Имя для нотификации.
    var name: Notification.Name
    
    /// Старое значение проперти.
    var oldValue: Any?
    
    /// Новое значение проперти.
    var newValue: Any?
    
    func post() {
        NotificationCenter.post(name: self.name, object: self)
    }
}

extension PropertyObserver {
    
    enum PropertyObserverError: Error {
        case notificationAlreadyAdded
    }
    
    private static var notifications = [Notification.Name: NSObjectProtocol]()
    
    static func observe(name: Notification.Name, handler: @escaping (PropertyObserver) -> Void) throws {
        if self.notifications.contains(where: { (key, _) -> Bool in return key == name }) {
            throw PropertyObserverError.notificationAlreadyAdded
        }
        
        let center = NotificationCenter.default
        let observer = center.addObserver(forName: name, object: nil, queue: .main) { (notification) in
            if let changeModel = notification.object as? PropertyObserver {
                handler(changeModel)
            }
        }
        
        self.notifications[name] = observer
    }
    
    static func removeObserve(name: Notification.Name) {
        self.notifications.removeValue(forKey: name)
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
    
    static var translationCollectionReloadIndexPaths: NSNotification.Name {
        return .init("rjtranslate.translCollectin.ReloadIndexPaths")
    }
}

extension NotificationCenter {
    
    static func post(name: Notification.Name, object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object)
    }
}

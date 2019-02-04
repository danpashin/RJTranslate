//
//  HTTPClientFacilities.swift
//  RJTranslate-App
//
//  Created by Даниил on 05/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

protocol URLTransformable {
    
    /// Преобразует данный класс в URL, если возможно
    ///
    /// - Returns: Возвращает класс URL или nil, если преобразование невозможно.
    func asURL() -> URL?
    
    /// Преобразует данный класс в String.
    ///
    /// - Returns: Возвращает строковое представаление адреса.
    func asString() -> String
}

extension String : URLTransformable {
    func asURL() -> URL? {
        return URL(string: self)
    }
    
    func asString() -> String {
        return self
    }
}

extension URL : URLTransformable {
    func asURL() -> URL? {
        return self
    }
    
    func asString() -> String {
        return self.absoluteString
    }
}

extension UIDevice {
    var identifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let deviceIdentifier = machineMirror.children.reduce("") { ID, element in
            guard let value = element.value as? Int8, value != 0 else { return ID }
            return ID + String(UnicodeScalar(UInt8(value)))
        }
        
        return deviceIdentifier
    }
}

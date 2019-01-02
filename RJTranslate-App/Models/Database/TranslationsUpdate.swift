//
//  TranslationsUpdate.swift
//  RJTranslate-App
//
//  Created by Даниил on 29/11/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation
import Alamofire

@objc class TranslationsUpdate: NSObject {
    
    /// Флаг определяет, должно ли производится обновление на данный момент.
    @objc public private(set) var canUpdate: Bool = false
    
    /// Содержит хэш-сумму обновления.
    public private(set) var hashSum: String?
    
    /// Адрес загрузки нового обновления.
    public private(set) var archiveURL: URL?
    
    private static let updatePreferenceKey = "latestTranslationsUpdateHash"
    
    init(dictionary: Dictionary<AnyHashable, Any>?) {
        if dictionary == nil {
            return
        }
        
        self.hashSum = dictionary!["hash_sum"] as? String
        
        if let stringURL: String = dictionary!["archive"] as? String {
            self.archiveURL = URL(string: stringURL)
        }
        
        if let savedHash: String = UserDefaults.standard.string(forKey: TranslationsUpdate.updatePreferenceKey) {
            self.canUpdate = (self.hashSum != savedHash)
        } else if hashSum?.count ?? 0 > 0 {
            self.canUpdate = true
        }
    }
    
    public func saveUpdate() {
        UserDefaults.standard.set(self.hashSum, forKey: TranslationsUpdate.updatePreferenceKey)
    }
    
    /// Выполняет загрузку архива из удаленного источника.
    ///
    /// - Parameters:
    ///   - progress: Прогресс загрузки. Вызывается на основном потоке.
    ///   - completion: Замыкание, в которое возвращается ошибка (если есть) и адрес загруженного архива.
    public func download(_ progress: @escaping(Progress) -> Void,
                         completion: @escaping(Error?, URL?) -> Void) {
        guard let url = self.archiveURL else {
            appRecordError("Archive URL is nil")
            return
        }
        
        let downloadDestination = DownloadRequest.suggestedDownloadDestination(for: .cachesDirectory)
        
        Alamofire.download(url, to: downloadDestination)
            .validate(statusCode: 200..<400)
            .downloadProgress(closure: progress)
            .response { (response:DefaultDownloadResponse) in
                if let error = response.error {
                    completion(error, nil)
                    return
                }
                
                self.saveUpdate()
                completion(nil, response.destinationURL)
        }
    }
}

//extension TranslationsUpdate: CustomStringConvertible {
//    var description: String {
//        return String(format: "<%@ url: '%@'; hash: '%@'>", NSStringFromClass(type(of: self)),
//                      String(describing: archiveURL), hashSum ?? "")
//    }
//}

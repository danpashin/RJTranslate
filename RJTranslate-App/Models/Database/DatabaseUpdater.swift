//
//  DatabaseUpdater.swift
//  RJTranslate-App
//
//  Created by Даниил on 17/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation
import Alamofire
import SSZipArchive
import Crashlytics

@objc protocol DatabaseUpdaterDelegate {
    /// Метод вызывается, когда апдейтер закончил обрабатывать модели приложений.
    ///
    /// - Parameters:
    ///   - updater: Экземляр апдейтера.
    ///   - models: Массив с обработанными моделями приложений.
    func databaseUpdater(_ updater: DatabaseUpdater, finishedUpdate models: [RJTApplicationModel]);
    
    /// Метод вызывается, когда апдейтер терпит неудачу. Это может быть как ошибка при загрузке локализаций, так и ошибка их обработки.
    ///
    /// - Parameters:
    ///   - updater: Экземляр апдейтера.
    ///   - error: Ошибка, которая произошла в процессе.
    func databaseUpdater(_ updater: DatabaseUpdater, failed error: Error);
    
    /// Метод вызывается, когда апдейтер начинает обновлять базу данных.
    ///
    /// - Parameter updater: Экземляр апдейтера.
    func databaseUpdaterDidStartUpdatingDatabase(_ updater: DatabaseUpdater);
    
    
    /// Метод вызывется, когда апдейтер обновляет прогресс обработки.
    ///
    /// - Parameters:
    ///   - updater: Экземпляр апдейтера.
    ///   - progress: Текущий прогресс обработки.
    @objc optional func databaseUpdater(_ updater : DatabaseUpdater, updateProgress progress: Double);
}


@objc class DatabaseUpdater : NSObject, SSZipArchiveDelegate {
    
    /// Делегат для объекта-обработчика статуса обновления.
    @objc public private(set) var delegate: DatabaseUpdaterDelegate
    private var currentUpdate: TranslationsUpdate?
    
    private var downloadProgress: Double = 0.0 {
        didSet {
            let progress = downloadProgress / 2.0 + unzipProgress / 2.0
            self.delegate.databaseUpdater?(self, updateProgress: progress)
        }
    }
    
    private var unzipProgress: Double = 0.0 {
        didSet {
            let progress = downloadProgress / 2.0 + unzipProgress / 2.0
            self.delegate.databaseUpdater?(self, updateProgress: progress)
        }
    }
    
    /// Выполняет инициализацию апдейтера.
    ///
    /// - Parameter delegate: Делегат для объекта-обработчика статуса обновления.
    @objc init(delegate: DatabaseUpdaterDelegate) {
        self.delegate = delegate;
    }
    
    /// Выполняет загрузку и последующую обработку моделей приложений.
    @objc public func performUpdate() {
        if self.currentUpdate?.archiveURL?.absoluteString.count ?? 0 > 0 {
            self.downloadUpdate()
        } else {
            self.checkTranslationsVersion { (updateModel:TranslationsUpdate?, error: Error?) in
                if error != nil {
                    self.delegate.databaseUpdater(self, failed: error!)
                } else {
                    self.currentUpdate = updateModel
                    self.downloadUpdate()
                }
            }
        }
    }
    
    /// Проверяет версию локализации приложений.
    ///
    /// - Parameter completion: Блок вызывается в конце проверки.
    @objc public func checkTranslationsVersion(_ completion: @escaping (TranslationsUpdate?, Error?) -> Void) {
        
        DispatchQueue.global().async {
            let url = RJTAPI.apiURL
            
            Alamofire.request(url.absoluteString)
                .validate(statusCode: 200..<400)
                .validate(contentType: ["application/json"])
                
                .responseJSON { response in
                if (response.error != nil) {
                    completion(nil, response.error)
                    return
                }
                
                guard let json = response.result.value as? Dictionary<String, Any> else {
                    print("\(String(describing: response.result.value))")
                    let error = NSError(domain: "ru.danpashin.rjtranslate.parsing", code: 0, userInfo: [NSLocalizedDescriptionKey : "Can not parse response."])
                    completion(nil, error)
                    return
                }
                
                let errorDict = json["error"] as? Dictionary<String, Any>
                if errorDict != nil {
                    let errorCode = errorDict!["code"] as? NSNumber
                    let errorDescription = errorDict!["description"] as? String ?? ""
                    let serverError = NSError(domain: "ru.danpashin.rjtranslate.server", code: errorCode?.intValue ?? 0, userInfo: [NSLocalizedDescriptionKey: errorDescription])
                    completion(nil, serverError)
                } else {
                    if let translationDict = json["translation"] as? Dictionary<String, Any> {
                        self.currentUpdate = TranslationsUpdate(dictionary: translationDict)
                        completion(self.currentUpdate, nil)
                    } else {
                        appRecordError("Can not parse update json.")
                        
                        let error = NSError(domain: "ru.danpashin.error", code: 0, userInfo: nil)
                        completion(nil, error)
                    }
                }
            }
        }
    }
    
    private func downloadUpdate() {
        self.currentUpdate?.download({ (progress:Progress) in
            self.downloadProgress += progress.fractionCompleted
        }, completion: { (error:Error?, tempURL:URL?) in
            if error != nil {
                appRecordError("Error while downloading update: \(String(describing: error))")
                return
            }
            
            let destinationPath = NSTemporaryDirectory().appending("translations")
            try? FileManager.default.createDirectory(atPath: destinationPath, withIntermediateDirectories: false, attributes: nil)
            
            SSZipArchive.unzipFile(atPath: tempURL!.path , toDestination: destinationPath, delegate: self)
        })
    }
    
    private func processFolder(_ folderPath: String) {
        let fileManager = FileManager.default
        var folderContents: [String]? = try? fileManager.contentsOfDirectory(atPath: folderPath)
        
        let predicate = NSPredicate(format: "self ENDSWITH '.plist'")
        folderContents = folderContents?.filter({ (string: String) -> Bool in
            return predicate.evaluate(with: string)
        })
        
        
        var modelsArray:[RJTApplicationModel] = []
        for fileName:String in folderContents ?? [] {
            let fullPath = String(format: "%@/%@", folderPath, fileName)
            guard let translationDict = NSDictionary(contentsOfFile: fullPath) else {
                appRecordError("Translation dictionary for file name %@ is nil", fileName)
                continue
            }
            
            guard let model = RJTApplicationModel.from(translationDict as! [AnyHashable : Any]) else {
                appRecordError("Can not parse model for file %@", fileName)
                continue
            }
            
            if !modelsArray.contains(model) {
                modelsArray.append(model)
            }
        }
        
        try? fileManager.removeItem(atPath: folderPath)
        
        if let database = UIApplication.shared.appDelegate.defaultDatabase {
            database.performFullDatabaseUpdate(with: modelsArray) {
                self.delegate.databaseUpdater(self, finishedUpdate: modelsArray)
            }
        }
        
    }
    
    // MARK: - SSZipArchiveDelegate -
    public func zipArchiveProgressEvent(_ loaded: UInt64, total: UInt64) {
        self.unzipProgress = Double(loaded / total);
    }
    
    public func zipArchiveDidUnzipArchive(atPath path: String, zipInfo: unz_global_info, unzippedPath: String) {
        DispatchQueue.global(qos: .`default`).async {
            self.processFolder(unzippedPath)
        }
    }
}

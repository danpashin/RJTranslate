//
//  DatabaseUpdater.swift
//  RJTranslate-App
//
//  Created by Даниил on 17/12/2018.
//  Copyright © 2018 Даниил. All rights reserved.
//

import Foundation
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


@objc class DatabaseUpdater : NSObject {
    
    /// Делегат для объекта-обработчика статуса обновления.
    @objc public private(set) var delegate: DatabaseUpdaterDelegate
    private var currentUpdate: TranslationsUpdate?
    
    private var updateDownloader: UpdateDownloader?
    
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
            self.checkTranslationsVersion { (updateModel: TranslationsUpdate?, error: NSError?) in
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
    @objc public func checkTranslationsVersion(_ completion: @escaping (TranslationsUpdate?, NSError?) -> Void) {
            
        HTTPClient.shared.json(HTTPClient.apiURL)?.completion({ (json: [String : AnyHashable]?, error: NSError?) in
            if json == nil || error != nil {
                completion(nil, error)
                return
            }
            
            let response = TranslationServerResponse(json: json)
            if response.error != nil {
                completion(nil, response.error!.asNSError())
            } else {
                self.currentUpdate = response.translation
            }
        })
    }
    
    private func downloadUpdate() {
        guard let update = self.currentUpdate else { return }
        
        self.updateDownloader = UpdateDownloader()
        self.updateDownloader?.downloadAndUnzipUpdate(update, progress: { (progress: Double) in
            self.delegate.databaseUpdater?(self, updateProgress: progress)
        }, completion: { (unzippedFolder: String?, error: NSError?) in
            if error != nil || unzippedFolder == nil { return }
            self.processFolder(unzippedFolder!)
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
}

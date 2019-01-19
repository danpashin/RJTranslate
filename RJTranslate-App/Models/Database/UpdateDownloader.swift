//
//  UpdateDownloader.swift
//  RJTranslate-App
//
//  Created by Даниил on 05/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation
import SSZipArchive

class UpdateDownloader: NSObject, SSZipArchiveDelegate {
    public typealias UpdateDownloaderCompletion = (_ folderPath : String?, _ error: NSError?) -> Void
    public typealias UpdateDownloaderProgress = (_ progress: Double) -> Void
    
    private var downloadProgress: Double = 0.0 {
        didSet {
            self.updateProgress()
        }
    }
    
    private var unzipProgress: Double = 0.0 {
        didSet {
            self.updateProgress()
        }
    }
    
    private var progressClosure: UpdateDownloaderProgress?
    private var completionClosure: UpdateDownloaderCompletion?
    
    private func updateProgress() {
        let totalProgress = self.downloadProgress / 2.0 + self.unzipProgress / 2.0
        self.progressClosure?(totalProgress)
    }
    
    
    /// Загружает и распаковывает архив с новыми локализациями.
    ///
    /// - Parameters:
    ///   - update: Экземпляр обновления.
    ///   - progress: Вызывается при обновлении прогресса загрузки и распаковки.
    ///   - completion: Вызывается по окончании процесса.
    public func downloadAndUnzipUpdate(_ update: TranslationsUpdate, 
                               progress : @escaping UpdateDownloaderProgress,
                               completion: @escaping UpdateDownloaderCompletion) {
        DispatchQueue(label: "ru.danpashin.rjtranslate.download.queue").async {
            guard let url = update.archiveURL else {
                let error = appRecordError("Update URL is nil")
                completion(nil, error)
                return
            }
            
            self.progressClosure = progress
            self.completionClosure = completion
            
            HTTPClient.shared.download(url)
                .progress({ (progress: Double) in
                    self.downloadProgress = progress
                })
                .completion({ (dataURL: URL?, error: NSError?) in
                    if error != nil || dataURL == nil {
                        if error != nil {
                            appRecordError(error!.localizedDescription)
                        }
                        completion(nil, error)
                        return
                    }
                    
                    self.performUnzipping(dataURL!)
                })
        }
    }
    
    /// Производит распаковку архива.
    ///
    /// - Parameter fileURL: Адрес архива в файловой системе.
    private func performUnzipping(_ fileURL: URL) {
        DispatchQueue(label: "ru.danpashin.rjtranslate.unzip.queue").async {
            let destinationPath = NSTemporaryDirectory().appending("translations")
            try? FileManager.default.createDirectory(atPath: destinationPath, withIntermediateDirectories: false, attributes: nil)
            
            SSZipArchive.unzipFile(atPath: fileURL.path , toDestination: destinationPath, delegate: self)
        }
    }
    
    // MARK: - SSZipArchiveDelegate -
    public func zipArchiveProgressEvent(_ loaded: UInt64, total: UInt64) {
        self.unzipProgress = Double(loaded / total);
    }
    
    public func zipArchiveDidUnzipArchive(atPath path: String, zipInfo: unz_global_info, unzippedPath: String) {
        DispatchQueue(label: "ru.danpashin.rjtranslate.unzip.queue").async {
            try? FileManager.default.removeItem(atPath: path)
            self.completionClosure?(unzippedPath, nil)
        }
    }
}

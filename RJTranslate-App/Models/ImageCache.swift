//
//  ImageCache.swift
//  RJTranslate-App
//
//  Created by Даниил on 27/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

enum ImageCacheType {
    
    /// Кэш хранится только в памяти и выгружается при ее недостатке.
    case memory
    
    /// Кэш хранится и в памяти и на диске.
    case memoryDisk
    
    /// Кэш хранится только на диске.
    case disk
}

class ImageCache {
    
     static let shared = ImageCache()
    
    /// Тип кэша. В памяти, дисковый или комбинированный.
    private(set) var type: ImageCacheType
    
   private let memoryCache = NSCache<NSString, UIImage>()
    
    /// Директория для кэшировния объектов на диск
   private var cacheDirectory: String
    
     init(type: ImageCacheType = .disk) {
        self.type = type
        
        let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        
        let bundleIdentifier = Bundle.main.bundleIdentifier
        self.cacheDirectory = "\(cacheDirectory ?? "")/\(bundleIdentifier ?? "")/images/"
        self.createCacheDirectory()

    }
    
   private func createCacheDirectory() {
        if !FileManager.default.fileExists(atPath: self.cacheDirectory) {
            try? FileManager.default.createDirectory(atPath: self.cacheDirectory, 
                                                     withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    /// Сохраняет или удаляет изображение в/из кэша.
    ///
    /// - Parameters:
    ///   - image: Изображение для сохранения.
    ///   - key: Уникальный ключ, идентифицирующий данное изображение.
    func save(image: UIImage?, forKey key: String) {
        if self.type == .memory || self.type == .memoryDisk {
            if image != nil {
                self.memoryCache.setObject(image!, forKey: key as NSString)
            } else {
                self.memoryCache.removeObject(forKey: key as NSString)
            }
        }
        
        
        if self.type == .disk || self.type == .memoryDisk {
            let fullPath = self.cacheDirectory + (key)
            if image != nil {
                guard let cgImage = image!.cgImage else { return }
                let newImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: image!.imageOrientation)
                try? newImage.pngData()!.write(to: URL(fileURLWithPath: fullPath))
            } else {
                try? FileManager.default.removeItem(atPath: fullPath)
            }
        }
    }
    
    /// Выдает изображение из кзша.
    ///
    /// - Parameter key: Уникальный ключ, идентифицирующий данное изображение.
    /// - Returns: Полученное изображение. Может быть nil.
    func image(key: String) -> UIImage? {
        if type == .disk {
            if let image = self.memoryCache.object(forKey: key as NSString) {
                return image
            }
        }
        
        if type != .memory {
            let fullPath = self.cacheDirectory + key
            if FileManager.default.fileExists(atPath: fullPath) {
                var image: UIImage? = nil
                if let data = NSData(contentsOfFile: fullPath) {
                    image = UIImage(data: data as Data)
                    
                    if let CGImage = image?.cgImage, let imageOrientation = image?.imageOrientation {
                        return UIImage(cgImage: CGImage, scale: UIScreen.main.scale, orientation: imageOrientation)
                    }
                }
            }
        }
        
        return nil
    }
    
    /// Подсчитывает размер кэша на диске.
    ///
    /// - Parameter completion: Вызывается в конце подсчета и передает размер кэша в байтах.
    func countSize(completion: @escaping (_ cacheSize: UInt) -> Void) {
        DispatchQueue.global(qos: .default).async {
            let fileManager = FileManager.default
            
            let folderURL = URL(fileURLWithPath: self.cacheDirectory)
            
            var totalSize: UInt = 0
            
            let properties: [URLResourceKey] = [
                .isRegularFileKey,
                .totalFileAllocatedSizeKey,
                .fileAllocatedSizeKey
            ]
            let enumerator = fileManager.enumerator(at: folderURL, 
                                                    includingPropertiesForKeys: properties, 
                                                    options: [], errorHandler: { url, error in
                                                        return true
            })
            
            while let resourceURL = enumerator?.nextObject() as? URL {
                let fileResource: NSNumber? = try? resourceURL.resourceValues(forKeys: [.isRegularFileKey])
                    .allValues.first?.value as? NSNumber
                if !(fileResource?.boolValue ?? true) {
                    continue
                }
                
                var fileSize: NSNumber? = try? resourceURL.resourceValues(forKeys: [.totalFileAllocatedSizeKey])
                    .allValues.first?.value as? NSNumber
                if fileSize == nil {
                    try? fileSize = resourceURL.resourceValues(forKeys: [.fileAllocatedSizeKey])
                        .allValues.first?.value as? NSNumber
                }
                
                totalSize += fileSize?.uintValue ?? 0
            }
            
            completion(totalSize)
        }
    }
    
    /// Выполняет полную очистку кэша в памяти и на диске.
    func flush() {
        DispatchQueue.global(qos: .default).async {
            self.memoryCache.removeAllObjects()
            try? FileManager.default.removeItem(atPath: self.cacheDirectory)
            self.createCacheDirectory()
        }
    }

}

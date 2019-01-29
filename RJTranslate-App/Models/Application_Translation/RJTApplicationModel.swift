//
//  RJTApplicationModel.swift
//  RJTranslate-App
//
//  Created by Даниил on 24/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

public extension RJTApplicationModel {
    static func loadFullModel(from translationSummary: API.TranslationSummary,
                                     completion: @escaping (RJTApplicationModel?, NSError?) -> Void) {
        HTTPClient.shared.json(translationSummary.url)
            .completion { (response: [String : AnyHashable]?, error: NSError?) in
                if response == nil {
                    completion(nil, error)
                    return
                }
                
                if let responseDict = response?["response"] as? [[String: AnyHashable]] {
                    if let translationDict = responseDict.first {
                        let model = RJTApplicationModel.from(translationDict)
                        completion(model, nil)
                        return
                    }
                }
                
                let error = API.SimpleError(code: 0, description: "Could'nt parse translation response")
                completion(nil, error.nserror)
        }
    }
    
    func loadIcon(_ completion: @escaping (_ icon: UIImage?) -> Void) {
        DispatchQueue.global().async {
            let cache = ImageCache.shared
            if let image = cache.image(key: self.displayedName) {
                completion(image)
                return
            }
            
            if self.bundleIdentifier?.count ?? 0 > 0 {
                let image = UIImage._applicationIconImage(forBundleIdentifier: self.bundleIdentifier!,
                                                          format: .default, scale: UIScreen.main.scale)
                completion(image)
            } else {
                let defaultIcon = LICreateDefaultIcon(15)!
                completion(UIImage(cgImage: defaultIcon.takeUnretainedValue()))
            }
        }
    }
}

fileprivate enum MIIconVariant: NSInteger {
    case small            // 29x29   29x29
    case spotlight        // 40x40   40x40
    case `default`          // 62x62   78x78
    case gameCenter       // 42x42   78x78
    case documentFull     // 37x48   37x48
    case documentSmall    // 37x48   37z48
    case squareBig        // 82x82   128x128
    case squareDefault    // 62x62   78x78
    case tiny             // 20x20   20x20
    case document         // 37x48   247x320
    case documentLarge    // 37x48   247x320
    case unknownGradient  // 300x150 300x150
    case squareGameCenter // 42x42   42x42
    case unknownDefault   // 62x62   78x78
}

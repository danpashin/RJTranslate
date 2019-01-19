//
//  HTTPClientPinning.swift
//  RJTranslate-App
//
//  Created by Даниил on 19/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

public func SHA256(data : Data) -> String {
    var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
    data.withUnsafeBytes {
        _ = CC_SHA256($0, CC_LONG(data.count), &hash)
    }
    return Data(bytes: hash).base64EncodedString()
}

class HTTPClientPinning {
    
    private static let api_rejail_ru_hash = "3ef7bJQlZHAyJbvsdzzvBYI+AG97FlV2nAepu9rGJvw="
    private static let rejail_ru_hash = "a1EtsSokHWrweQbX9Eprw3Taj3UUvlLJ0wGyE0mzmvY="
    
    public static func validateServerTrust(_ serverTrust: SecTrust?) -> Bool {
        if serverTrust == nil {
            return false
        }
        
        var secresult = SecTrustResultType.invalid
        let status = SecTrustEvaluate(serverTrust!, &secresult)
        if status != errSecSuccess {
            return false
        }
        
        if SecTrustGetCertificateCount(serverTrust!) == 0 { return false }
        guard let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust!, 0)  else { return false }
        if #available(iOS 10.3, *) {
            guard let publicKey = SecCertificateCopyPublicKey(serverCertificate) else { return false }
            guard let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil) else { return false }
            let keyHash = SHA256(data: publicKeyData as Data)
//            print("Key hash \(keyHash)")
            
            return keyHash == api_rejail_ru_hash || keyHash == rejail_ru_hash
        } else {
            return true
        }
    }
}

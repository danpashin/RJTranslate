//
//  PinningConveniences.swift
//  RJTranslate-App
//
//  Created by Даниил on 25/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

fileprivate struct ASN1Headers {
   private static let rsa2048: [UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ]
    
   private static let rsa4096: [UInt8] = [
        0x30, 0x82, 0x02, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x02, 0x0f, 0x00
    ]
    
    fileprivate static func headerFor(size: Int) -> [UInt8] {
        if size == 4096 {
            return self.rsa4096
        }
        
        return self.rsa2048
    }
}

 func SHA256(data : Data) -> String {
    var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
    data.withUnsafeBytes {
        _ = CC_SHA256($0, CC_LONG(data.count), &hash)
    }
    return Data(bytes: hash).base64EncodedString()
}


extension SecCertificate {
    var Key: SecKey? {
        var trust: SecTrust?
        let policy = SecPolicyCreateBasicX509()
        SecTrustCreateWithCertificates(self, policy, &trust)
        
        if trust != nil {
            var result = SecTrustResultType.invalid
            SecTrustEvaluate(trust!, &result)
            
            return SecTrustCopyPublicKey(trust!)
        }
        
        return nil
    }
}

extension SecKey {
    var keyHash: String {
        var keySize = 2048
        
        if let attributes = SecKeyCopyAttributes(self) as? [String: AnyObject] {
            if let size = attributes[kSecAttrKeySizeInBits as String] as? NSNumber {
                keySize = size.intValue
            }
        }
        
        var hashData = Data(bytes: ASN1Headers.headerFor(size: keySize))
        hashData.append(SecKeyCopyExternalRepresentation(self, nil)! as Data)
        
        return SHA256(data: hashData)
    }
}

//
//  HTTPClientPinning.swift
//  RJTranslate-App
//
//  Created by Даниил on 19/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class HTTPClientPinning {
    
    public static var enablePinning = true
    private static var hashes: [String: String] = [:]
    
    public static func validateServerTrust(_ serverTrust: SecTrust, domain: String) -> Bool {
        if !self.enablePinning {
            return true
        }
        
        var secresult = SecTrustResultType.invalid
        let status = SecTrustEvaluate(serverTrust, &secresult)
        if status != errSecSuccess {
            return false
        }
        
        let certsCount = SecTrustGetCertificateCount(serverTrust)
        for i in (0..<certsCount) {
            guard let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, i) else { continue }
            guard let publicKey = serverCertificate.publicKey else { continue }
            
            if self.hashes[domain] == publicKey.keyHash {
                return true
            }
        }
        
        return false
    }
    
    public static func addTrustFor(domain: String, keyHash: String) {
        self.hashes[domain] = keyHash
    }
}

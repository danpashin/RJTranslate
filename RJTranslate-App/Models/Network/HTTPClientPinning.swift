//
//  HTTPClientPinning.swift
//  RJTranslate-App
//
//  Created by Даниил on 19/01/2019.
//  Copyright © 2019 Даниил. All rights reserved.
//

import Foundation

class HTTPClientPinning {
    
    private static let hashes: [String] = [
        "/7HcrFbhXchKnpl0XlNGwuOZmIVi53GOUnAYHACoD6s=", // api.rejail.ru
        "NAZrOsLKtF5drHMC0mE3+6ncFGHBD9LHUCWsJ+TSgXE="  // translations.rejail.ru
    ]
    
    public static func validateServerTrust(_ serverTrust: SecTrust?) -> Bool {
        if serverTrust == nil {
            return false
        }
        
        var secresult = SecTrustResultType.invalid
        let status = SecTrustEvaluate(serverTrust!, &secresult)
        if status != errSecSuccess {
            return false
        }
        
        let certsCount = SecTrustGetCertificateCount(serverTrust!)
        for i in (0..<certsCount) {
            guard let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust!, i) else { continue }
            guard let publicKey = serverCertificate.publicKey else { continue }
            
            if self.hashes.contains(publicKey.keyHash) {
                return true
            }
        }
        
        return false
    }
}

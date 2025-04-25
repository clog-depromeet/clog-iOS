//
//  TokenAuthenticationCredential.swift
//  Networker
//
//  Created by Junyoung on 4/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Alamofire

struct TokenAuthenticationCredential: AuthenticationCredential {
    
    private let token: TokenDTO?
    
    init(_ token: TokenDTO?) {
        self.token = token
    }
    
    var accessToken: String? {
        guard let token = token else {
            return nil
        }
        return token.accessToken
    }
    
    var refreshToken: String? {
        guard let token = token else {
            return nil
        }
        return token.refreshToken
    }
    
    var requiresRefresh: Bool {
        guard let token = token else {
            return true
        }
        return isExpired(token.refreshToken)
    }
}

extension TokenAuthenticationCredential {
    private func isExpired(_ refreshToken: String) -> Bool {
        let segments = refreshToken.components(separatedBy: ".")
        guard let expired = decodeJWTPart(segments[1]) else { return true }
        let expiredDate = Date(timeIntervalSince1970: Double(expired)).addingTimeInterval(-20)
        return expiredDate < Date()
    }
    
    private func decodeJWTPart(_ value: String) -> Int? {
        guard let bodyData = base64UrlDecode(value),
              let json = try? JSONSerialization.jsonObject(with: bodyData, options: []),
              let payload = json as? [String: Any],
              let exp = payload["exp"] as? Int else {
            return nil
        }
        return exp
    }
    
    private func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 += padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
}

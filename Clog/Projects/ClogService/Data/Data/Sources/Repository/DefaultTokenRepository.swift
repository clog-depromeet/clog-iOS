//
//  DefaultTokenRepository.swift
//  Data
//
//  Created by Junyoung on 4/26/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import TokenDomain

public struct DefaultTokenRepository: TokenRepository {
    public var accessToken: String? {
        getAccessToken()
    }
    public var refreshToken: String? {
        getRefreshToken()
    }
    public var isAccessTokenExpired: Bool {
        isExpired(accessToken)
    }
    public var isRefreshTokenExpired: Bool {
        isExpired(refreshToken)
    }
    
    private let tokenDataSource: TokenDataSource
    private let authDataSource: AuthDataSource
    
    public init(
        tokenDataSource: TokenDataSource,
        authDataSource: AuthDataSource
    ) {
        self.tokenDataSource = tokenDataSource
        self.authDataSource = authDataSource
    }
    
    public func refresh(_ refreshToken: String) async throws -> AuthToken {
        try await authDataSource.refresh(refreshToken: refreshToken).toToken()
    }
    
    public func saveToken(_ token: AuthToken) {
        tokenDataSource.saveToken(token)
    }
}

extension DefaultTokenRepository {
    private func getAccessToken() -> String? {
        tokenDataSource.loadToken()?.accessToken
    }
    
    private func getRefreshToken() -> String? {
        tokenDataSource.loadToken()?.refreshToken
    }
    
    private func isExpired(_ token: String?) -> Bool {
        guard let token else { return true }
        let segments = token.components(separatedBy: ".")
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

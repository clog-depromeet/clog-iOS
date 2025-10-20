//
//  TokenDataSource.swift
//  Data
//
//  Created by Junyoung on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Networker
import TokenDomain

public protocol TokenDataSource {
    func saveToken(_ token: AuthToken)
    func saveProvider(_ provider: String)
    func loadToken() -> AuthToken?
    func loadProvider() -> String?
    func clearToken()
}

public struct DefaultTokenDataSource: TokenDataSource {
    public init () {}
    
    public func saveToken(_ token: AuthToken) {
        try? KeychainManager.shared.deleteItem(
            ofClass: AppData.LoginUserKeychainKey.token.itemClass,
            key: AppData.LoginUserKeychainKey.token.rawValue
        )

        AppData.token = token
    }
    
    public func saveProvider(_ provider: String) {
        AppData.provider = provider
    }
    
    @Sendable public func loadToken() -> AuthToken? {
        AppData.token
    }
    
    @Sendable public func loadProvider() -> String? {
        AppData.provider
    }
    
    public func clearToken() {
        AppData.clearLocalData()
    }
}

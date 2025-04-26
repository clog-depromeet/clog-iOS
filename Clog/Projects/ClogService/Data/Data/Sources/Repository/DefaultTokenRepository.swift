//
//  DefaultTokenRepository.swift
//  Data
//
//  Created by Junyoung on 3/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import AccountDomain
import Networker

public struct DefaultTokenRepository: TokenRepository {
    let dataSource: TokenDataSource
    
    public init(dataSource: TokenDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetchLoginType() -> LoginType {
        guard let provider = dataSource.loadProvider() else {
            return .apple
        }
        return LoginType.init(provider)
    }
    
    public func getRefreshToken() -> String? {
        return dataSource.loadToken()?.refreshToken
    }

    public func clearToken() async {
        dataSource.clearToken()
    }
}

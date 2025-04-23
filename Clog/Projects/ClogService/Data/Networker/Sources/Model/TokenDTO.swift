//
//  TokenDTO.swift
//  Networker
//
//  Created by soi on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct TokenDTO: Sendable {
    
    public init(
        accessToken: String,
        refreshToken: String,
        provider: String
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.provider = provider
    }
    
    let accessToken: String
    public let refreshToken: String
    public let provider: String
}

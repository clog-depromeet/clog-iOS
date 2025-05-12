//
//  Token.swift
//  TokenDomain
//
//  Created by Junyoung on 4/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct AuthToken: Sendable, Codable {
    public let accessToken: String
    public let refreshToken: String
    
    public init(
        accessToken: String,
        refreshToken: String
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

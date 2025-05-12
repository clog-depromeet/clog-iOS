//
//  AuthTokenResponseDTO.swift
//  Data
//
//  Created by soi on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Networker
import TokenDomain

public struct AuthTokenDTO: Codable {
    let accessToken: String
    let refreshToken: String
    let provider: String
    
    func toToken() -> AuthToken {
        AuthToken(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
    
    func toProvider() -> String {
        return provider
    }
}

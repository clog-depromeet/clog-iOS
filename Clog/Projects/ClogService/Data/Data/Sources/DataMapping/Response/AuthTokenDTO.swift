//
//  AuthTokenResponseDTO.swift
//  Data
//
//  Created by soi on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Networker

public struct AuthTokenDTO: Codable {
    let accessToken: String
    let refreshToken: String
    let provider: String
    
    func toToken() -> TokenDTO {
        TokenDTO(
            accessToken: accessToken,
            refreshToken: refreshToken,
            provider: provider
        )
    }
}

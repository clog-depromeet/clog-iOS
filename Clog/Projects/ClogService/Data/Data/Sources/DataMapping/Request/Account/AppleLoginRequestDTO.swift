//
//  AuthTokenRequestDTO.swift
//  Data
//
//  Created by soi on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct AppleLoginRequestDTO: Encodable {
    let code: String
    let codeVerifier: String
}

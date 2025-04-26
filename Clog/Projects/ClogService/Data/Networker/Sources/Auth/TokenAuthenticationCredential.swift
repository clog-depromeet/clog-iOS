//
//  TokenAuthenticationCredential.swift
//  Networker
//
//  Created by Junyoung on 4/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Alamofire

import Shared
import TokenDomain

struct TokenAuthenticationCredential: AuthenticationCredential {
    
    private var tokenRepository: TokenRepository {
        ClogDI.container.resolve(TokenRepository.self)!
    }
    
    var accessToken: String? {
        return tokenRepository.accessToken
    }
    
    var refreshToken: String? {
        return tokenRepository.refreshToken
    }
    
    var requiresRefresh: Bool {
        return tokenRepository.isAccessTokenExpired
    }
}

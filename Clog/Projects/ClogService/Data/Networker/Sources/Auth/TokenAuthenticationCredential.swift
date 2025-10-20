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
    
    private var token: AuthToken?
    private var tokenRepository: TokenRepository {
        ClogDI.container.resolve(TokenRepository.self)!
    }
    
    public init(token: AuthToken? = nil) {
        self.token = token
    }
    
    var accessToken: String? {
        if let token {
            return token.accessToken
        } else {
            return tokenRepository.accessToken
        }
    }
    
    var refreshToken: String? {
        if let token {
            return token.refreshToken
        } else {
            return tokenRepository.refreshToken
        }
    }
    
    var requiresRefresh: Bool {
        return tokenRepository.isAccessTokenExpired
    }
}

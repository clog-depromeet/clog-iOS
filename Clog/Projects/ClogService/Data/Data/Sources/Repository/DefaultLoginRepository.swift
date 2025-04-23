//
//  DefaultLoginRepository.swift
//  Data
//
//  Created by soi on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import AccountDomain

public struct DefaultLoginRepository: LoginRepository {
    private let authDataSource: AuthDataSource
    private let tokenDataSource: TokenDataSource
    
    public init(
        authDataSource: AuthDataSource,
        tokenDataSource: TokenDataSource
    ) {
        self.authDataSource = authDataSource
        self.tokenDataSource = tokenDataSource
    }
    
    public func login(_ idToken: String) async throws {
        let response: AuthTokenDTO = try await authDataSource.kakaoLogin(
            idToken: idToken
        )
        
        // Token 저장
        tokenDataSource.saveToken(response)
    }
    
    public func login(code: String, codeVerifier: String) async throws {
        let response: AuthTokenDTO = try await authDataSource.appleLogin(
            code: code,
            codeVerifier: codeVerifier
        )
        // Token 저장
        tokenDataSource.saveToken(response)
    }

    public func refreshToken(_ refreshToken: String) async throws {
        let response: AuthTokenDTO = try await authDataSource.refresh(refreshToken: refreshToken)

        // Token 저장
        tokenDataSource.saveToken(response)
    }
}

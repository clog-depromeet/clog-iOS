//
//  TokenRepository.swift
//  TokenDomain
//
//  Created by Junyoung on 4/26/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol TokenRepository {
    var accessToken: String? { get }
    var refreshToken: String? { get }
    var isAccessTokenExpired: Bool { get }
    var isRefreshTokenExpired: Bool { get }
    
    func refresh(_ refreshToken: String) async throws -> AuthToken
    func saveToken(_ token: AuthToken)
}

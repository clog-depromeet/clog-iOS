//
//  LoginRepository.swift
//  AccountDomain
//
//  Created by soi on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol LoginRepository {
    func login(_ idToken: String) async throws
    func login(code: String, codeVerifier: String) async throws
    func refreshToken(_ refrshToken: String) async throws
}

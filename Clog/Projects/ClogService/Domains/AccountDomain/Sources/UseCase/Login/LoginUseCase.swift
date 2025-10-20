//
//  LoginUseCase.swift
//  AccountDomain
//
//  Created by soi on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Dependencies
import Shared

public protocol LoginUseCase {
    func execute(idToken: String) async throws
    func execute(code: String, codeVerifier: String) async throws
    func execute(refreshToken: String) async throws
}

public struct DefaultLoginUseCase: LoginUseCase {
    public init(repository: LoginRepository) {
        self.repository = repository
    }
    
    private let repository: LoginRepository
    
    public func execute(idToken: String) async throws {
        try await repository.login(idToken)
    }
    
    public func execute(code: String, codeVerifier: String) async throws {
        try await repository.login(code: code, codeVerifier: codeVerifier)
    }

    public func execute(refreshToken: String) async throws {
        try await repository.refreshToken(refreshToken)
    }
}

enum LoginUseCaseKey: DependencyKey {
    static let liveValue = ClogDI.container.resolve(LoginUseCase.self)!
}

extension DependencyValues {
    public var loginUseCase: LoginUseCase {
        get { self[LoginUseCaseKey.self] }
        set { self[LoginUseCaseKey.self] = newValue }
    }
}

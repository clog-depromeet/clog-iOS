//
//  AccountUseCase.swift
//  AccountDomain
//
//  Created by Junyoung on 3/30/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Shared
import Dependencies

// TODO: 추후 분리 필요

// MARK: - Interface
public protocol AccountUseCase {
    func fetchAccount() async throws -> User
    func updateName(_ name: String) async throws
}

// MARK: - Implement
public struct Account: AccountUseCase {
    private let repository: AccountRepository
    
    public init(repository: AccountRepository) {
        self.repository = repository
    }
    
    public func fetchAccount() async throws -> User {
        try await repository.fetchAccount()
    }
    
    public func updateName(_ name: String) async throws {
        try await repository.updateName(name)
    }
}

// MARK: - Mock
public struct MockAccount: AccountUseCase {
    public func fetchAccount() -> User {
        User(id: 0, name: "")
    }
    
    public func updateName(_ name: String) {
        
    }
    
}

// MARK: - DependencyKey
public enum AccountDependencyKey: DependencyKey {
    public static var liveValue: any AccountUseCase = ClogDI.container.resolve(AccountUseCase.self)!
    
//    public static var testValue: any AccountUseCase = MockAccount()
    
//    public static var previewValue: any AccountUseCase = MockAccount()
}

public extension DependencyValues {
    var accountUseCase: any AccountUseCase {
        get { self[AccountDependencyKey.self] }
        set { self[AccountDependencyKey.self] = newValue }
    }
}

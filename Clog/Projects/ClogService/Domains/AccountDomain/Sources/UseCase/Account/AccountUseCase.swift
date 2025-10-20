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
    
    /// editAccount
    ///
    /// 유저 정보 수정 기존에 값이 있다면 수정하지 않은 값도 같이 담아서 보냄
    ///
    /// - Parameters:
    ///   - request: EditUserRequest(이름, 키, 팔길이, 인스타 주소)
    /// - Returns: Void
    ///
    func editAccount(_ request: EditUserRequest) async throws
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
    
    public func editAccount(_ request: EditUserRequest) async throws {
        try await repository.editAccount(request)
    }
}

// MARK: - Mock
public struct MockAccount: AccountUseCase {
    public func fetchAccount() -> User {
        User(id: 0, name: nil, height: nil, armSpan: nil, instagramUrl: nil)
    }
    
    public func updateName(_ name: String) {
        
    }
    
    public func editAccount(_ request: EditUserRequest) async throws {
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

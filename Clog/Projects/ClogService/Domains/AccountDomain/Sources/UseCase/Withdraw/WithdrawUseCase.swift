//
//  WithdrawUseCase.swift
//  AccountDomain
//
//  Created by Junyoung on 3/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Foundation
import Dependencies
import Shared

public protocol WithdrawUseCase {
    func execute(_ authorizationCode: String?) async throws
}

public struct Withdraw: WithdrawUseCase {
    public init(repository: WithdrawRepository) {
        self.repository = repository
    }
    
    private let repository: WithdrawRepository
    
    public func execute(_ authorizationCode: String?) async throws {
        try await repository.execute(authorizationCode)
    }
}

public struct MockWithdrawUseCase: WithdrawUseCase {
    public func execute(_ authorizationCode: String?) async throws {
        
    }
}

public enum WithdrawDependencyKey: DependencyKey {
    public static var liveValue: any WithdrawUseCase = ClogDI.container.resolve(WithdrawUseCase.self)!
    
//    public static var testValue: any WithdrawUseCase = MockWithdrawUseCase()
    
//    public static var previewValue: any WithdrawUseCase = MockWithdrawUseCase()
}

public extension DependencyValues {
    var withdrawUseCase: any WithdrawUseCase {
        get { self[WithdrawDependencyKey.self] }
        set { self[WithdrawDependencyKey.self] = newValue }
    }
}

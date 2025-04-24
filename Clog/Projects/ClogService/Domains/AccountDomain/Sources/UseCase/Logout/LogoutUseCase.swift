//
//  LogoutUseCase.swift
//  AccountDomain
//
//  Created by Junyoung on 3/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Dependencies
import Shared

public protocol LogoutUseCase {
    func execute() async throws
}

public struct Logout: LogoutUseCase {
    public init(repository: LogoutRepository) {
        self.repository = repository
    }
    
    private let repository: LogoutRepository
    
    public func execute() async throws {
        try await repository.logout()
    }
}

public struct MockLogoutUseCase: LogoutUseCase {
    public func execute() async throws {
        
    }
}

public enum LogoutDependencyKey: DependencyKey {
    public static var liveValue: any LogoutUseCase = ClogDI.container.resolve(LogoutUseCase.self)!
    
//    public static var testValue: any LogoutUseCase = MockLogoutUseCase()
    
//    public static var previewValue: any LogoutUseCase = MockLogoutUseCase()
}

public extension DependencyValues {
    var logoutUseCase: any LogoutUseCase {
        get { self[LogoutDependencyKey.self] }
        set { self[LogoutDependencyKey.self] = newValue }
    }
}


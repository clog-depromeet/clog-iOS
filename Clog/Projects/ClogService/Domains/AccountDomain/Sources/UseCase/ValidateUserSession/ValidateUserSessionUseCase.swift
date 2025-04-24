//
//  ValidateUserSessionUseCase.swift
//  AccountDomain
//
//  Created by Junyoung on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Dependencies
import Shared

public protocol ValidateUserSessionUseCase {
    func getRefreshToken() -> String?
}

public struct ValidateUserSession: ValidateUserSessionUseCase {
    public init(repository: TokenRepository) {
        self.repository = repository
    }
    
    private let repository: TokenRepository
    
    public func getRefreshToken() -> String? {
        repository.getRefreshToken()
    }
}

public struct MockValidateUserSession: ValidateUserSessionUseCase {
    public func getRefreshToken() -> String? {
        return nil
    }
}

public enum ValidateUserSessionDependencyKey: DependencyKey {
    public static var liveValue: any ValidateUserSessionUseCase = ClogDI.container.resolve(ValidateUserSessionUseCase.self)!
    
//    public static var testValue: any ValidateUserSessionUseCase = MockValidateUserSession()
    
//    public static var previewValue: any ValidateUserSessionUseCase = MockValidateUserSession()
}

public extension DependencyValues {
    var validateUserSessionUseCase: any ValidateUserSessionUseCase {
        get { self[ValidateUserSessionDependencyKey.self] }
        set { self[ValidateUserSessionDependencyKey.self] = newValue }
    }
}

//
//  SaveAttemptUseCase.swift
//  VideoDomain
//
//  Created by Junyoung on 3/29/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Shared
import Dependencies

// MARK: - Interface
public protocol SaveAttemptUseCase {
    func register(_ request: AttemptRequest) async throws
}

// MARK: - Implement
public struct SaveAttempt: SaveAttemptUseCase {
    private let repository: SaveAttemptRepository
    
    public init(repository: SaveAttemptRepository) {
        self.repository = repository
    }
    
    public func register(_ request: AttemptRequest) async throws {
        try await repository.register(request)
    }
}

// MARK: - Mock
public struct MockSaveAttempt: SaveAttemptUseCase {
    public func register(_ request: AttemptRequest) async throws {
        
    }
}

// MARK: - DependencyKey
public enum SaveAttemptDependencyKey: DependencyKey {
    public static var liveValue: any SaveAttemptUseCase = ClogDI.container.resolve(SaveAttemptUseCase.self)!
    
//    public static var testValue: any SaveAttemptUseCase = MockSaveAttempt()
    
//    public static var previewValue: any SaveAttemptUseCase = MockSaveAttempt()
}

public extension DependencyValues {
    var saveAttemptUseCase: any SaveAttemptUseCase {
        get { self[SaveAttemptDependencyKey.self] }
        set { self[SaveAttemptDependencyKey.self] = newValue }
    }
}

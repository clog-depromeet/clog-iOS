//
//  FilteredAttemptsUseCase.swift
//  FolderDomain
//
//  Created by soi on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

import Dependencies

public protocol FilteredAttemptsUseCase {
    func execute(_ filter: AttemptFilter?) async throws -> [Attempt]
}

public struct DefaultFilteredAttemptsUseCase: FilteredAttemptsUseCase {
    public let attemptRepository: AttemptRepository
    
    public init(attemptRepository: AttemptRepository) {
        self.attemptRepository = attemptRepository
    }
    
    public func execute(_ filter: AttemptFilter?) async throws -> [Attempt] {
        try await attemptRepository.getFilteredAttempts(filter)
    }
}

enum FilteredAttemptsUseCaseKey: DependencyKey {
    static let liveValue: FilteredAttemptsUseCase = ClogDI.container.resolve(FilteredAttemptsUseCase.self)!
}

extension DependencyValues {
    public var filteredAttemptsUseCase: FilteredAttemptsUseCase {
        get { self[FilteredAttemptsUseCaseKey.self] }
        set { self[FilteredAttemptsUseCaseKey.self] = newValue }
    }
}

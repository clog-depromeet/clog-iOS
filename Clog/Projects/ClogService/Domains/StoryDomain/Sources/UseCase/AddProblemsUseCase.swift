//
//  AddProblemsUseCase.swift
//  StoryDomain
//
//  Created by soi on 6/27/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

import Dependencies

public protocol AddProblemsUseCase {
    func execute(_ problems: AddProblems) async throws
}

public struct DefaultAddProblemsUseCase: AddProblemsUseCase {
    private let repository: AddProblemsRepository
    
    public init(repository: AddProblemsRepository) {
        self.repository = repository
    }
    
    public func execute(_ problems: AddProblems) async throws {
        try await repository.execute(problems)
    }
}

public enum AddProblemsDependencyKey: DependencyKey {
    public static var liveValue: AddProblemsUseCase = ClogDI.container.resolve(AddProblemsUseCase.self)!
}

public extension DependencyValues {
    var addProblemsUseCase: AddProblemsUseCase {
        get { self[AddProblemsDependencyKey.self] }
        set { self[AddProblemsDependencyKey.self] = newValue }
    }
}

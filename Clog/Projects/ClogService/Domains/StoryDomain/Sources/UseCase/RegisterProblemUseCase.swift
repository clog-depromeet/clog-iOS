//
//  RegisterProblemUseCase.swift
//  StoryDomain
//
//  Created by Junyoung on 3/30/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Shared
import Dependencies

// MARK: - Interface
public protocol RegisterProblemUseCase {
    func execute(storyId: Int, gradeId: Int?) async throws -> Int
}

// MARK: - Implement
public struct RegisterProblem: RegisterProblemUseCase {
    private let repository: ProblemRepository
    
    public init(repository: ProblemRepository) {
        self.repository = repository
    }
    
    public func execute(storyId: Int, gradeId: Int?) async throws -> Int {
        try await repository.execute(storyId: storyId, gradeId: gradeId)
    }
}

// MARK: - Mock
public struct MockRegisterProblem: RegisterProblemUseCase {
    
    public init() {
        
    }
    
    public func execute(storyId: Int, gradeId: Int?) async throws -> Int {
        return 0
    }
    
}

// MARK: - DependencyKey
public enum RegisterProblemDependencyKey: DependencyKey {
    public static var liveValue: any RegisterProblemUseCase = ClogDI.container.resolve(RegisterProblemUseCase.self)!
}

public extension DependencyValues {
    var registerProblemUseCase: any RegisterProblemUseCase {
        get { self[RegisterProblemDependencyKey.self] }
        set { self[RegisterProblemDependencyKey.self] = newValue }
    }
}

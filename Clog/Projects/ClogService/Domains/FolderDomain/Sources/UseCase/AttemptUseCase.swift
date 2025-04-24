//
//  AttemptUseCase.swift
//  FolderDomain
//
//  Created by soi on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

import ComposableArchitecture

public protocol AttemptUseCase {
    func execute(attemptId: Int) async throws -> ReadAttempt
    func patchResult(attemptId: Int, attempt: ReadAttempt, result: AttemptResult) async throws
    func patchInfo(attemptId: Int, attempt: ReadAttempt, grade: Grade?, crag: Crag?) async throws
    func delete(attemptId: Int) async throws
}

enum AttemptUseCaseKey: DependencyKey {
    static let liveValue: AttemptUseCase = ClogDI.container.resolve(AttemptUseCase.self)!
}

extension DependencyValues {
    public var attemptUseCase: AttemptUseCase {
        get { self[AttemptUseCaseKey.self] }
        set { self[AttemptUseCaseKey.self] = newValue }
    }
}

public struct DefaultAttemptUseCase: AttemptUseCase {
    private let attemptRepository: AttemptRepository
    
    public init(attemptRepository: AttemptRepository) {
        self.attemptRepository = attemptRepository
    }
    
    public func execute(attemptId: Int) async throws -> ReadAttempt {
        try await attemptRepository.getAttempt(attemptId: attemptId)
    }
    
    public func patchResult(attemptId: Int, attempt: ReadAttempt, result: AttemptResult) async throws {
        try await attemptRepository.patchResult(attemptId: attemptId, attempt: attempt, result: result)
    }
    
    public func delete(attemptId: Int) async throws {
        try await attemptRepository.deleteAttempt(attemptId: attemptId)
    }
    
    public func patchInfo(attemptId: Int, attempt: ReadAttempt, grade: Grade? = nil, crag: Crag? = nil) async throws {
        try await attemptRepository.patchInfo(attemptId: attemptId, attempt: attempt, grade: grade, crag: crag)
    }
}

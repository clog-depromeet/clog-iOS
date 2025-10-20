//
//  DefaultAttemptRepository.swift
//  Data
//
//  Created by soi on 3/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import FolderDomain
import Shared

public struct DefaultAttemptRepository: AttemptRepository {
    private let dataSource: AttemptDataSource
    
    public init(dataSource: AttemptDataSource) {
        self.dataSource = dataSource
    }
    
    public func getFilteredAttempts(_ filter: AttemptFilter?) async throws -> [Attempt] {
        let request = AttemptFilterRequestDTO(
            attemptStatus: filter?.attemptResult?.rawValue,
            cragId: filter?.crag?.id,
            gradeId: filter?.grade?.id
        )
        return try await dataSource.attempts(request).map { $0.toDomain() }
    }
    
    public func getAttempt(attemptId: Int) async throws -> ReadAttempt {
        try await dataSource.attempt(attemptId).toDomain()
    }
    
    public func deleteAttempt(attemptId: Int) async throws {
        try await dataSource.delete(attemptId)
    }
    
    public func patchResult(attemptId: Int, attempt: ReadAttempt, result: AttemptResult) async throws {
        try await dataSource.patch(id: attemptId, cragId: nil, gradeId: nil, unregisterGrade: nil, result: result.rawValue)
    }
    
    public func patchInfo(attemptId: Int, attempt: ReadAttempt, grade: Grade? = nil, crag: Crag? = nil) async throws {
        try await dataSource.patch(
            id: attemptId,
            cragId: crag?.id,
            gradeId: grade?.id,
            unregisterGrade: grade == nil,
            result: nil
        )
    }
}

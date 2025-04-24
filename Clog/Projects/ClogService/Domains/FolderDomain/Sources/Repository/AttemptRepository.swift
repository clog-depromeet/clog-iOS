//
//  AttemptRepository.swift
//  FolderDomain
//
//  Created by soi on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public protocol AttemptRepository {
    func getFilteredAttempts(_ filter: AttemptFilter?) async throws -> [Attempt]
    func getAttempt(attemptId: Int) async throws -> ReadAttempt
    func patchResult(attemptId: Int, attempt: ReadAttempt, result: AttemptResult) async throws
    func patchInfo(attemptId: Int, attempt: ReadAttempt, grade: Grade?, crag: Crag?) async throws
    func deleteAttempt(attemptId: Int) async throws
}

// TODO: Remove
public struct MockAttemptRepository: AttemptRepository {
    
    public init() {}
    
    public func getFilteredAttempts(_ filter: AttemptFilter?) async throws -> [Attempt] {
        [
            Attempt(
                id: 0,
                date: "2024-03-13",
                grade: Grade(id: 0, name: "V5", hexCode: "0xFF5733"),
                result: .complete,
                thumbnailUrl: "https://www.dictionary.com/e/wp-content/uploads/2018/05/lhtm.jpg",
                recordedTime: "00:45",
                crag: Crag(id: 0, name: "Seoul Bouldering", address: "Seoul, South Korea")
            ),
        ]
    }
    
    public func getAttempt(attemptId: Int) async throws -> ReadAttempt {
        throw NSError(domain: "attempt error", code: 0)
    }
    
    public func patchResult(attemptId: Int, attempt: ReadAttempt, result: AttemptResult) async throws {
        throw NSError(domain: "attempt", code: 0)
    }
    
    public func deleteAttempt(attemptId: Int) async throws {
        throw NSError(domain: "attempt", code: 0)
    }
    
    public func patchInfo(attemptId: Int, attempt: ReadAttempt, grade: Grade?, crag: Crag?) async throws {
        throw NSError(domain: "attempt", code: 0)
    }
}

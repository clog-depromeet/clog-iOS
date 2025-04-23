//
//  ReadAttempt.swift
//  FolderDomain
//
//  Created by soi on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public struct ReadAttempt: Hashable, Identifiable {
    public var id: UUID
    
    public let storyId: Int
    public let problemId: Int
    public let date: String
    public let grade: Grade?
    public let crag: Crag?
    public let result: AttemptResult?
    public let attempt: ReadAttemptDetail
    
    public init(id: UUID = UUID(), storyId: Int, problemId: Int, date: String, grade: Grade?, crag: Crag?, result: AttemptResult?, attempt: ReadAttemptDetail) {
        self.id = id
        self.storyId = storyId
        self.problemId = problemId
        self.date = date
        self.grade = grade
        self.crag = crag
        self.result = result
        self.attempt = attempt
    }
    
    public func copyWith(
        id: UUID? = nil,
        storyId: Int? = nil,
        problemId: Int? = nil,
        date: String? = nil,
        grade: Grade?? = nil,
        crag: Crag?? = nil,
        result: AttemptResult?? = nil,
        attempt: ReadAttemptDetail? = nil
    ) -> ReadAttempt {
        return ReadAttempt(
            id: id ?? self.id,
            storyId: storyId ?? self.storyId,
            problemId: problemId ?? self.problemId,
            date: date ?? self.date,
            grade: grade ?? self.grade,
            crag: crag ?? self.crag,
            result: result ?? self.result,
            attempt: attempt ?? self.attempt
        )
    }
}

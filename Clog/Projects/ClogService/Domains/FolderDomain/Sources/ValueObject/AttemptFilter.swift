//
//  AttemptFilter.swift
//  FolderDomain
//
//  Created by soi on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public struct AttemptFilter: Equatable {
    public let attemptResult: AttemptResult?
    public let crag: Crag?
    public let grade: Grade?
    
    public init(
        attemptResult: AttemptResult? = nil,
        crag: Crag? = nil,
        grade: Grade? = nil
    ) {
        self.attemptResult = attemptResult
        self.crag = crag
        self.grade = grade
    }
    
    public func toggleResult(_ newResult: AttemptResult?) -> AttemptFilter {
        let result: AttemptResult? = attemptResult == newResult ? nil : (newResult ?? attemptResult?.toggleResult())
        
        return AttemptFilter(
            attemptResult: result,
            crag: crag,
            grade: grade
        )
    }
    
    public func updateResult(_ result: AttemptResult?) -> AttemptFilter {
        AttemptFilter(
            attemptResult: attemptResult != result ? result : nil,
            crag: crag,
            grade: grade
        )
    }
    
    public func updateCrag(_ crag: Crag?) -> AttemptFilter {
        AttemptFilter(
            attemptResult: attemptResult,
            crag: crag,
            grade: grade
        )
    }
    
    public func updateGrade(_ grade: Grade?) -> AttemptFilter {
        AttemptFilter(
            attemptResult: attemptResult,
            crag: crag,
            grade: grade
        )
    }
}

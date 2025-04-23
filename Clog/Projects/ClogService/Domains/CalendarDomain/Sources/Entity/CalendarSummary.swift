//
//  CalendarSummary.swift
//  CalendarDomain
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct CalendarSummary: Equatable {
    public let numOfClimbDays: Int
    public let totalDurationMs: Int
    public let totalAttemptCount: Int
    public let successAttemptCount: Int
    public let failAttemptCount: Int
    
    public init(
        numOfClimbDays: Int,
        totalDurationMs: Int,
        totalAttemptCount: Int,
        successAttemptCount: Int,
        failAttemptCount: Int
    ) {
        self.numOfClimbDays = numOfClimbDays
        self.totalDurationMs = totalDurationMs
        self.totalAttemptCount = totalAttemptCount
        self.successAttemptCount = successAttemptCount
        self.failAttemptCount = failAttemptCount
    }
    
    public init() {
        self.numOfClimbDays = 0
        self.totalDurationMs = 0
        self.totalAttemptCount = 0
        self.successAttemptCount = 0
        self.failAttemptCount = 0
    }
}

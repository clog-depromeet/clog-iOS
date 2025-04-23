//
//  StoryProblem.swift
//  StoryDomain
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

// 클라이밍 문제 정보
public struct StoryProblem: Hashable, Equatable {
    public let id: Int
    public let attempts: [StoryAttempt]
    public let successCount: Int
    public let failCount: Int
    public let colorHex: String?
    
    public init(
        id: Int,
        attempts: [StoryAttempt],
        successCount: Int,
        failCount: Int,
        colorHex: String?
    ) {
        self.id = id
        self.attempts = attempts
        self.successCount = successCount
        self.failCount = failCount
        self.colorHex = colorHex
    }
}

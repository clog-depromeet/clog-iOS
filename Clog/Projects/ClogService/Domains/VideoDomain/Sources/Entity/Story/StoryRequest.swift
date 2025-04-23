//
//  StoryRequest.swift
//  StoryDomain
//
//  Created by Junyoung on 3/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct StoryRequest {
    public let cragId: Int?
    public let problem: ProblemRequest
    public let attempt: AttemptRequest
    public let memo: String?
    
    public init(
        cragId: Int?,
        problem: ProblemRequest,
        attempt: AttemptRequest,
        memo: String?
    ) {
        self.cragId = cragId
        self.problem = problem
        self.attempt = attempt
        self.memo = memo
    }
}

public struct ProblemRequest {
    public let gradeId: Int?
    
    public init(gradeId: Int?) {
        self.gradeId = gradeId
    }
}

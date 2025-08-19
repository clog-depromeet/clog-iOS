//
//  AttemptRequest.swift
//  StoryDomain
//
//  Created by Junyoung on 3/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public struct AttemptRequest {
    public let status: AttemptStatus
    public let problemId: Int?
    public let video: VideoRequest
    
    public init(
        status: AttemptStatus,
        problemId: Int?,
        video: VideoRequest
    ) {
        self.status = status
        self.problemId = problemId
        self.video = video
    }
}

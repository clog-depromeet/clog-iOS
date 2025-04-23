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

public struct VideoRequest {
    public let localPath: String
    public let thumbnailUrl: String?
    public let durationMs: Int
    public let stamps: [StampRequest]
    
    public init(
        localPath: String,
        thumbnailUrl: String?,
        durationMs: Int,
        stamps: [StampRequest]
    ) {
        self.localPath = localPath
        self.thumbnailUrl = thumbnailUrl
        self.durationMs = durationMs
        self.stamps = stamps
    }
}

public struct StampRequest {
    public let timeMs: Int
    
    public init(
        timeMs: Int
    ) {
        self.timeMs = timeMs
    }
}

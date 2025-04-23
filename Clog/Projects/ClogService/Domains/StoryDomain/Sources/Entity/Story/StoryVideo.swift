//
//  StoryVideo.swift
//  StoryDomain
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

// 클라이밍 영상 정보
public struct StoryVideo: Hashable, Equatable {
    public let id: Int
    public let localPath: String
    public let thumbnailUrl: String?
    public let durationMs: Int
    public let stamps: [StoryStamp]
    
    public init(
        id: Int,
        localPath: String,
        thumbnailUrl: String?,
        durationMs: Int,
        stamps: [StoryStamp]
    ) {
        self.id = id
        self.localPath = localPath
        self.thumbnailUrl = thumbnailUrl
        self.durationMs = durationMs
        self.stamps = stamps
    }
}

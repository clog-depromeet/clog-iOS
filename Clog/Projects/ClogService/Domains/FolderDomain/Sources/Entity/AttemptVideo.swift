//
//  AttemptVideo.swift
//  FolderDomain
//
//  Created by soi on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

// TODO: Stroy Video Shared와 동일
public struct AttemptVideo: Hashable, Equatable {
    public let id: Int
    public let localPath: String
    public let thumbnailUrl: String?
    public let durationMs: Int
    public let stamps: [AttemptStamp]
    
    public init(
        id: Int,
        localPath: String,
        thumbnailUrl: String?,
        durationMs: Int,
        stamps: [AttemptStamp]
    ) {
        self.id = id
        self.localPath = localPath
        self.thumbnailUrl = thumbnailUrl
        self.durationMs = durationMs
        self.stamps = stamps
    }
}

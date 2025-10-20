//
//  VideoRequest.swift
//  Shared
//
//  Created by soi on 7/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

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

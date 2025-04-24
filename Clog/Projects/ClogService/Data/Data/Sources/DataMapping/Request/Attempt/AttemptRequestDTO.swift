//
//  AttemptRequestDTO.swift
//  Data
//
//  Created by Junyoung on 3/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct AttemptRequestDTO: Encodable {
    public let status: String
    public let problemId: Int?
    public let video: VideoRequestDTO
}

public struct VideoRequestDTO: Encodable {
    public let localPath: String
    public let thumbnailUrl: String?
    public let durationMs: Int
    public let stamps: [StampRequestDTO]
}

public struct StampRequestDTO: Encodable {
    public let timeMs: Int
}

//
//  StoryVideoResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import StoryDomain

// 클라이밍 영상 정보
struct StoryVideoResponseDTO: Decodable {
    let id: Int
    let localPath: String
    let thumbnailUrl: String?
    let durationMs: Int
    let stamps: [StoryStampResponseDTO]
    
    func toDomain() -> StoryVideo {
        return StoryVideo(
            id: id,
            localPath: localPath,
            thumbnailUrl: thumbnailUrl,
            durationMs: durationMs,
            stamps: stamps.map { $0.toDomain() }
        )
    }
}

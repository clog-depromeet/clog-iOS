//
//  AttemptVideoResponseDTO.swift
//  Data
//
//  Created by soi on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import FolderDomain

struct AttemptVideoResponseDTO: Decodable {
    let id: Int
    let localPath: String
    let thumbnailUrl: String?
    let durationMs: Int
    let stamps: [AttemptStampResponseDTO]
    
    func toDomain() -> AttemptVideo {
        AttemptVideo(
            id: id,
            localPath: localPath,
            thumbnailUrl: thumbnailUrl,
            durationMs: durationMs,
            stamps: stamps.map { $0.toDomain(durationMs: durationMs) }
        )
    }
}

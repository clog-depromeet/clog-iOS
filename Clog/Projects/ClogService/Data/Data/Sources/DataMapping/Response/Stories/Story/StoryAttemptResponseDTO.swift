//
//  StoryAttemptResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import StoryDomain

// 클라이밍 시도 정보
struct StoryAttemptResponseDTO: Decodable {
    let id: Int
    let status: String
    let video: StoryVideoResponseDTO
    
    func toDomain() -> StoryAttempt {
        return StoryAttempt(
            id: id,
            status: .init(value: status),
            video: video.toDomain()
        )
    }
}

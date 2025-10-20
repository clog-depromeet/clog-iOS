//
//  StoryStampResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import StoryDomain

// 클라이밍 스탬프 정보
struct StoryStampResponseDTO: Decodable {
    let id: Int
    let timeMs: Int
    
    func toDomain() -> StoryStamp {
        return StoryStamp(
            id: id,
            timeMs: timeMs
        )
    }
}

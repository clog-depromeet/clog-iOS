//
//  StoryProblemResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import StoryDomain

// 클라이밍 문제 정보
struct StoryProblemResponseDTO: Decodable {
    let id: Int
    let attempts: [StoryAttemptResponseDTO]
    let successCount: Int
    let failCount: Int
    let colorHex: String?
    
    func toDomain() -> StoryProblem {
        return StoryProblem(
            id: id,
            attempts: attempts.map { $0.toDomain() },
            successCount: successCount,
            failCount: failCount,
            colorHex: colorHex
        )
    }
}

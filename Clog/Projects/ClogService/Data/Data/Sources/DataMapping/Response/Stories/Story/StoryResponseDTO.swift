//
//  StoryResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import StoryDomain

public struct StoryResponseDTO: Decodable {
    let id: Int
    let totalDurationMs: Int
    let problems: [StoryProblemResponseDTO]
    let colorHex: String?
    
    func toDomain() -> Story {
        return Story(
            id: id,
            totalDurationMs: totalDurationMs,
            problems: problems.map { $0.toDomain() }
        )
    }
}

//
//  StoryResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import CalendarDomain

public struct CalendarStoryResponseDTO: Decodable {
    let id: Int
    let totalDurationMs: Int
    let cragName: String?
    let thumbnailUrl: String?
    let problems: [CalendarProblemResponseDTO]
    
    func toDomain() -> CalendarStory {
        return CalendarStory(
            id: id,
            totalDurationMs: totalDurationMs,
            cragName: cragName ?? "",
            thumbnailUrl: thumbnailUrl,
            problems: problems.map { $0.toDomain() }
        )
    }
}

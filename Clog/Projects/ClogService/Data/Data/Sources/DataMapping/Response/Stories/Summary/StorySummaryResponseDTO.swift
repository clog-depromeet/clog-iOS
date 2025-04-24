//
//  StorySummaryResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import StoryDomain

public struct StorySummaryResponseDTO: Decodable {
    let id: Int
    let cragName: String?
    let totalDurationMs: Int
    let totalAttemptsCount: Int
    let totalSuccessCount: Int
    let totalFailCount: Int
    let memo: String?
    let problems: [StorySummaryProblemResponseDTO]
    let date: String
    let thumbnailUrl: String?
    
    func toDomain() -> StorySummary {
        return StorySummary(
            id: id,
            cragName: cragName,
            totalDurationMs: totalDurationMs,
            totalAttemptsCount: totalAttemptsCount,
            totalSuccessCount: totalSuccessCount,
            totalFailCount: totalFailCount,
            memo: memo,
            problems: problems.map { $0.toDomain() },
            date: date,
            thumbnailUrl: thumbnailUrl
        )
    }
}

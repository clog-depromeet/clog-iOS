//
//  StorySummaryProblemResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import StoryDomain

struct StorySummaryProblemResponseDTO: Decodable {
    let id: Int
    let attemptCount: Int
    let colorHex: String?
    
    func toDomain() -> StorySummaryProblem {
        return StorySummaryProblem(
            id: id,
            attemptCount: attemptCount,
            colorHex: colorHex
        )
    }
}

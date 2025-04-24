//
//  CalendarSummaryResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import CalendarDomain

struct CalendarSummaryResponseDTO: Decodable {
    let numOfClimbDays: Int
    let totalDurationMs: Int
    let totalAttemptCount: Int
    let successAttemptCount: Int
    let failAttemptCount: Int
    
    func toDomain() -> CalendarSummary {
        return CalendarSummary(
            numOfClimbDays: numOfClimbDays,
            totalDurationMs: totalDurationMs,
            totalAttemptCount: totalAttemptCount,
            successAttemptCount: successAttemptCount,
            failAttemptCount: failAttemptCount
        )
    }
}

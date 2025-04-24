//
//  CalendarResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import CalendarDomain

public struct CalendarResponseDTO: Decodable {
    let summary: CalendarSummaryResponseDTO
    let days: [CalendarDayResponseDTO]
    
    func toDomain() -> ClimbCalendar {
        return ClimbCalendar(
            summary: summary.toDomain(),
            days: days.map { $0.toDomain() }
        )
    }
}

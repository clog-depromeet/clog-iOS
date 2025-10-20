//
//  DayResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import CalendarDomain

public struct CalendarDayResponseDTO: Decodable {
    public let date: String
    public let thumbnailUrl: String?
    public let stories: [CalendarStoryResponseDTO]
    
    func toDomain() -> CalendarDay {
        return CalendarDay(
            date: date.toDate(),
            thumbnail: thumbnailUrl?.isEmpty ?? true ? nil : thumbnailUrl,
            stories: stories.map { $0.toDomain() }
        )
    }
}

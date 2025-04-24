//
//  ClimbeDays.swift
//  Domain
//
//  Created by Junyoung on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct CalendarDay: Hashable, Identifiable {
    public var id: UUID { UUID() }
    public let date: Date
    public let thumbnail: String?
    public let stories: [CalendarStory]
    
    public var displayDate: String {
        let calendar = Calendar.current
        let selectedComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        if let year = selectedComponents.year,
           let month = selectedComponents.month,
           let day = selectedComponents.day
        {
            return "\(year).\(month).\(day)"
        } else {
            return ""
        }
    }
    
    public var isCurrentMonth: Bool
    public var hasItem: Bool
    
    public init(
        date: Date,
        thumbnail: String?,
        stories: [CalendarStory],
        isCurrentMonth: Bool = true,
        hasItem: Bool = false
    ) {
        self.date = date
        self.thumbnail = thumbnail
        self.stories = stories
        self.isCurrentMonth = isCurrentMonth
        self.hasItem = hasItem
    }
}

extension CalendarDay {
    public static var mock: [CalendarDay] {
        [
            CalendarDay(
                date: Date(),
                thumbnail: "https://fastly.picsum.photos/id/482/200/300.jpg?hmac=sZqH9D718kRNYORntdoWP-EehCC83NaK3M-KTWvABIg",
                stories: []
            ),
            CalendarDay(
                date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                thumbnail: "https://fastly.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U",
                stories: []
            ),
            CalendarDay(
                date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
                thumbnail: "https://fastly.picsum.photos/id/482/200/300.jpg?hmac=sZqH9D718kRNYORntdoWP-EehCC83NaK3M-KTWvABIg",
                stories: []
            ),
            CalendarDay(
                date: Calendar.current.date(byAdding: .day, value: 4, to: Date())!,
                thumbnail: "https://fastly.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U",
                stories: []
            ),
        ]
    }
    
    // 스토리 암장명으로 그룹화
    public var groupedStories: [String: [CalendarStory]] {
        Dictionary(grouping: stories, by: {$0.cragName} )
    }
}

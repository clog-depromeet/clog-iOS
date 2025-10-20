//
//  Calendar.swift
//  CalendarDomain
//
//  Created by Junyoung on 3/11/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct ClimbCalendar {
    public let summary: CalendarSummary
    public let days: [CalendarDay]
    
    public init(
        summary: CalendarSummary,
        days: [CalendarDay]
    ) {
        self.summary = summary
        self.days = days
    }
}

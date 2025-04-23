//
//  CalendarRepository.swift
//  CalendarDomain
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol CalendarRepository {
    func fetch(year: Int, month: Int) async throws -> ClimbCalendar
}

public final class MockCalendarRepository: CalendarRepository {
    // 2025년 3월 1~30일 목데이터
    let mockCalendar = (1...30).compactMap { day -> CalendarDay? in
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var components = DateComponents()
        components.year = 2025
        components.month = 3
        components.day = Int(day)
        
        guard let date = calendar.date(from: components) else { return nil }
        
        return CalendarDay(
            date: date,
            thumbnail: "https://example.com/thumbnail\(day).jpg",
            stories: []
        )
    }
    
    private var error: FetchCalendarError?
    
    public func setError() {
        error = FetchCalendarError.unknown
    }
    
    public func fetch(year: Int, month: Int) async throws -> ClimbCalendar {
        if let error { throw error }
        
        // 입력된 year, month에 해당하는 데이터만 필터링
        let filteredDays = mockCalendar.filter { day in
            let components = Calendar.current.dateComponents([.year, .month], from: day.date)
            return components.year == year && components.month == month
        }
        return ClimbCalendar(
            summary: CalendarSummary(),
            days: filteredDays
        )
    }
}

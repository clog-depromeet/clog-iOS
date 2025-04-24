//
//  DefaultCalendarRepository.swift
//  Data
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import CalendarDomain

public struct DefaultCalendarRepository: CalendarRepository {
    private let dataSource: CalendarDataSource
    
    public init(dataSource: CalendarDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch(year: Int, month: Int) async throws -> ClimbCalendar {
        let request = YearMonthRequestDTO(year: year, month: month)
        return try await dataSource.calendars(request).toDomain()
    }
}

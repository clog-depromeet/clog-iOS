//
//  CalendarUseCase.swift
//  CalendarDomain
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Dependencies
import Shared

public enum FetchCalendarError: Error {
    case unknown
}

public protocol FetchCalendarUseCase {
    func fetch(_ date: Date) async throws -> ClimbCalendar
}

public struct FetchCalendar: FetchCalendarUseCase {
    private let repository: CalendarRepository
    
    public init(repository: CalendarRepository) {
        self.repository = repository
    }
    
    public func fetch(_ date: Date) async throws -> ClimbCalendar {
        do {
            return try await repository.fetch(
                year: date.year,
                month: date.month
            )
        } catch {
            throw FetchCalendarError.unknown
        }
    }
}

public struct MockFetchCalendar: FetchCalendarUseCase {
    public func fetch(_ date: Date) async throws -> ClimbCalendar {
        ClimbCalendar(summary: CalendarSummary(), days: [])
    }
}

public enum FetchCalendarDependencyKey: DependencyKey {
    public static var liveValue: any FetchCalendarUseCase = ClogDI.container.resolve(FetchCalendarUseCase.self)!
}

public extension DependencyValues {
    var fetchCalendarUseCase: any FetchCalendarUseCase {
        get { self[FetchCalendarDependencyKey.self] }
        set { self[FetchCalendarDependencyKey.self] = newValue }
    }
}

//
//  CalendarTest.swift
//  CalendarDomainTests
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Testing
import Foundation
@testable import CalendarDomain

@Suite()
struct FetchCalendarTest {
    let date: Date
    init() {
        // 현재 날짜 2025월 3월 고정
        var components = DateComponents()
        components.year = 2025
        components.month = 3
        components.day = 1 // 날짜를 1일로 설정
        
        self.date = Calendar.current.date(from: components)!
    }
    
    @Test func 캘린더_데이터_조회_성공() async throws {
        let mockRepository = MockCalendarRepository()
        let useCase = FetchCalendar(repository: mockRepository)
        
        do {
            let result = try await useCase.fetch(date)
            #expect(result.days.count == 30)
            #expect(result.numOfClimbDays == 30)
        } catch {
            Issue.record()
        }
    }

    @Test func 캘린더_데이터_조회_실패() async throws {
        let mockRepository = MockCalendarRepository()
        mockRepository.setError()
        
        let useCase = FetchCalendar(repository: mockRepository)
        
        do {
            let _ = try await useCase.fetch(date)
            Issue.record()
        } catch {
            #expect(error as? FetchCalendarError == .unknown)
        }
    }
}

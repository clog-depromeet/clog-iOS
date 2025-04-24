//
//  FutureMonthCheckerTest.swift
//  CalendarDomainTests
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Testing

@testable import CalendarDomain

@Suite
struct FutureMonthCheckerTest {
    
    private let calendar: Calendar
    
    init() {
        calendar = Calendar.current
    }
    
    @Test
    func 입력_날짜가_현재_달_한달전_False() async throws {
        let useCase: FutureMonthCheckerUseCase = FutureMonthChecker()
        
        // 선택된 날짜
        var selected = self.calendar.dateComponents([.year, .month], from: Date())
        selected.year = 2025
        selected.month = 2
        
        // 현재 2025.03
        var current = self.calendar.dateComponents([.year, .month], from: Date())
        current.year = 2025
        current.month = 3
        
        #expect(!useCase.execute(selectedMonth: selected, currentMonth: current))
    }

    @Test
    func 입력_날짜가_현재_달_일년전_False() async throws {
        let useCase: FutureMonthCheckerUseCase = FutureMonthChecker()
        
        // 선택된 날짜
        var selected = self.calendar.dateComponents([.year, .month], from: Date())
        selected.year = 2024
        selected.month = 3
        
        // 현재 2025.03
        var current = self.calendar.dateComponents([.year, .month], from: Date())
        current.year = 2025
        current.month = 3
        
        #expect(!useCase.execute(selectedMonth: selected, currentMonth: current))
    }
    
    @Test
    func 입력_날짜가_현재_달_같음_True() async throws {
        let useCase: FutureMonthCheckerUseCase = FutureMonthChecker()
        
        // 선택된 날짜
        var selected = self.calendar.dateComponents([.year, .month], from: Date())
        selected.year = 2025
        selected.month = 3
        
        // 현재 2025.03
        var current = self.calendar.dateComponents([.year, .month], from: Date())
        current.year = 2025
        current.month = 3
        
        #expect(useCase.execute(selectedMonth: selected, currentMonth: current))
    }
    
    @Test
    func 입력_날짜가_현재_달_초과_True() async throws {
        let useCase: FutureMonthCheckerUseCase = FutureMonthChecker()
        
        // 선택된 날짜
        var selected = self.calendar.dateComponents([.year, .month], from: Date())
        selected.year = 2025
        selected.month = 5
        
        // 현재 2025.03
        var current = self.calendar.dateComponents([.year, .month], from: Date())
        current.year = 2025
        current.month = 3
        
        #expect(useCase.execute(selectedMonth: selected, currentMonth: current))
    }
}

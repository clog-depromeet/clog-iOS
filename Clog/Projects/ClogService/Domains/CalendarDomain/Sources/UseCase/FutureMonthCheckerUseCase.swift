//
//  MonthLimitUseCase.swift
//  Domain
//
//  Created by Junyoung on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Dependencies
import Shared

public protocol FutureMonthCheckerUseCase {
    func execute(selectedMonth: DateComponents, currentMonth: DateComponents) -> Bool
}

public struct FutureMonthChecker: FutureMonthCheckerUseCase {
    public init() {}
    
    public func execute(selectedMonth: DateComponents, currentMonth: DateComponents) -> Bool {
        guard let selectedYear = selectedMonth.year,
              let selectedMonth = selectedMonth.month,
              let currentYear = currentMonth.year,
              let currentMonth = currentMonth.month
        else {
            return true
        }
        
        if selectedYear == currentYear {
            return selectedMonth >= currentMonth
        } else {
            return false
        }
    }
}

public struct MockFutureMonthChecker: FutureMonthCheckerUseCase {
    public init() {}
    
    public func execute(selectedMonth: DateComponents, currentMonth: DateComponents) -> Bool {
        return false
    }
}

public enum FutureMonthCheckerDependencyKey: DependencyKey {
    public static var liveValue: any FutureMonthCheckerUseCase = ClogDI.container.resolve(FutureMonthCheckerUseCase.self)!
}

public extension DependencyValues {
    var futureMonthCheckerUseCase: any FutureMonthCheckerUseCase {
        get { self[FutureMonthCheckerDependencyKey.self] }
        set { self[FutureMonthCheckerDependencyKey.self] = newValue }
    }
}


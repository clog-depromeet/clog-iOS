//
//  CalendarFeature.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture
import CalendarDomain

@Reducer
public struct CalendarFeature {
    private let calendar = Calendar.current
    
    @ObservableState
    public struct State: Equatable {
        var selectedDate: Date = Date()
        var isDisableNextMonth: Bool = false
        var days: [CalendarDay] = []
        var selectedDay: CalendarDay? = nil
        
        var isPresentBottomSheet: Bool = false
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case dayTapped(CalendarDay)
        
        case previousMonthTapped
        case nextMonthTapped
        case updateCalendar(days: [CalendarDay], selectedDay: Date)
        case isCurrentMonthLast(Bool)
        case storyTapped(Int)
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .dayTapped(let day):
                state.selectedDay = day
                state.isPresentBottomSheet = !day.stories.isEmpty
                return .none
            case .storyTapped(let storyId):
                state.isPresentBottomSheet = false
                return .none
                
            case .isCurrentMonthLast(let isLast):
                state.isDisableNextMonth = isLast
                return .none
            case .updateCalendar(let days, let selectedDate):
                state.selectedDate = selectedDate
                state.days = getDays(for: selectedDate, calendarDay: days)
                return .none
            default:
                return .none
            }
        }
    }
}

extension CalendarFeature {
    
    private func getDays(for date: Date, calendarDay: [CalendarDay]) -> [CalendarDay] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let firstDayOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else { return [] }
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
        var tempDays: [CalendarDay] = []
        
        //  이전 달의 남은 날짜 추가
        if firstWeekday > 0,
           let previousMonth = calendar.date(byAdding: .month, value: -1, to: firstDayOfMonth),
           let previousMonthDays = calendar.range(of: .day, in: .month, for: previousMonth) {
            
            let startDay = max(1, min(previousMonthDays.count, previousMonthDays.count - firstWeekday + 1)) // ✅ 범위 조정
            let endDay = previousMonthDays.count
            
            for day in startDay...endDay {
                if let date = calendar.date(bySetting: .day, value: day, of: previousMonth) {
                    tempDays.append(
                        CalendarDay(
                            date: date,
                            thumbnail: "",
                            stories: [],
                            isCurrentMonth: false
                        )
                    )
                }
            }
        }
        
        //  현재 달의 날짜 추가
        for day in range {
            if let date = calendar.date(bySetting: .day, value: day, of: firstDayOfMonth) {
                
                // 서버 데이터에서 해당 날짜의 이벤트 찾기
                let matchedEvent = calendarDay.first(where: { calendar.isDate($0.date, inSameDayAs: date) })
                
                let isEmptyStory = matchedEvent?.stories.isEmpty ?? true
                
                let calendarDay = CalendarDay(
                    date: date,
                    thumbnail: matchedEvent?.thumbnail,
                    stories: matchedEvent?.stories ?? [],
                    isCurrentMonth: true,
                    hasItem: isEmptyStory ? false : true
                )
                
                tempDays.append(calendarDay)
            }
        }
        
        //  남은 칸 계산 (7일 단위 유지)
        let remainder = tempDays.count % 7
        if remainder > 0 {
            let nextMonthStart = 1
            if let nextMonth = calendar.date(byAdding: .month, value: 1, to: firstDayOfMonth) {
                for day in nextMonthStart..<(7 - remainder + 1) {
                    if let date = calendar.date(bySetting: .day, value: day, of: nextMonth) {
                        tempDays.append(
                            CalendarDay(
                                date: date,
                                thumbnail: "",
                                stories: [],
                                isCurrentMonth: false
                            )
                        )
                    }
                }
            }
        }
        
        return tempDays
    }
}

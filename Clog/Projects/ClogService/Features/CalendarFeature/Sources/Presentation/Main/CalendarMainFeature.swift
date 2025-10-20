//
//  CalendarFeature.swift
//  CalendarFeatureFeature
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture
import CalendarDomain

@Reducer
public struct CalendarMainFeature {
    
    @Dependency(\.fetchCalendarUseCase) private var fetchCalendarUseCase
    @Dependency(\.futureMonthCheckerUseCase) private var futureMonthCheckerUseCase
    private let calendar = Calendar.current
    
    @ObservableState
    public struct State: Equatable {
        
        var calendarCurrentDate: Date = Date()
        
        var userInfoState = UserInfoFeature.State()
        var calendarState = CalendarFeature.State()
        public init() {}
    }
    
    public enum Action {
        case userInfoAction(UserInfoFeature.Action)
        case calendarAction(CalendarFeature.Action)
        case onAppear
        case moveToCalendarDetail(Int)
        
        case fetch(Date)
        case isCurrentMonthLast(Bool)
        case fetchSuccess(ClimbCalendar)
        case fetchFailure(Error)
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        
        Scope(state: \.userInfoState, action: \.userInfoAction) {
            UserInfoFeature()
        }
        
        Scope(state: \.calendarState, action: \.calendarAction) {
            CalendarFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return moveMonth(
                    direction: 0,
                    currentDate: state.calendarCurrentDate
                )
                
            case .calendarAction(let action):
                switch action {
                case .nextMonthTapped:
                    return moveMonth(
                        direction: 1,
                        currentDate: state.calendarCurrentDate
                    )
                case .previousMonthTapped:
                    return moveMonth(
                        direction: -1,
                        currentDate: state.calendarCurrentDate
                    )
                case .storyTapped(let storyId):
                    return .send(.moveToCalendarDetail(storyId))
                default:
                    return .none
                }
                
            case .fetch(let newDate):
                state.calendarCurrentDate = newDate
                return .merge(
                    fetchCalendar(state.calendarCurrentDate),
                    validateNextMonth(state.calendarCurrentDate)
                )
                
            case .isCurrentMonthLast(let isLast):
                return .send(.calendarAction(.isCurrentMonthLast(isLast)))
                
            case .fetchSuccess(let calendar):
                return .merge(
                    .send(
                        .calendarAction(
                            .updateCalendar(
                                days: calendar.days,
                                selectedDay: state.calendarCurrentDate
                            )
                        )
                    ),
                    .send(
                        .userInfoAction(
                            .updateCalendarInfo(calendar.summary)
                        )
                    ),
                    .send(
                        .userInfoAction(
                            .updateCurrentMonth(state.calendarCurrentDate.month)
                        )
                    )
                )
                
            case .fetchFailure(let error):
                print(error)
                return .none
                
            default:
                return .none
            }
        }
    }
}

extension CalendarMainFeature {
    // 달 이동
    private func moveMonth(direction: Int, currentDate: Date) -> Effect<Action> {
        .run { send in
            if let newDate = calendar.date(
                byAdding: .month,
                value: direction,
                to: currentDate
            ) {
                await send(.fetch(newDate))
            }
        }
    }
    
    // 선택된 달에 해당되는 Calendar 데이터 가져오기
    private func fetchCalendar(_ date: Date) -> Effect<Action> {
        .run { send in
            do {
                let data = try await fetchCalendarUseCase.fetch(date)
                await send(.fetchSuccess(data))
            } catch {
                await send(.fetchFailure(error))
            }
        }
    }
    
    // 선택된 달 다음달이 이번 달을 초과하는지 검증
    private func validateNextMonth(_ date: Date) -> Effect<Action> {
        .run { send in
            let calendar = Calendar.current
            let selectedComponents = calendar.dateComponents([.year, .month], from: date)
            let currentComponents = calendar.dateComponents([.year, .month], from: Date())
            
            let isLast = futureMonthCheckerUseCase.execute(
                selectedMonth: selectedComponents,
                currentMonth: currentComponents
            )
            
            await send(.isCurrentMonthLast(isLast))
        }
    }
}

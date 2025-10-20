//
//  ReportFeature.swift
//  ReportFeature
//
//  Created by Junyoung on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture
import ReportDomain

@Reducer
public struct ReportFeature {
    @Dependency(\.reportFetcherUseCase) private var reportFetcherUseCase

    @ObservableState
    public struct State: Equatable {
        public let reportUser: ReportUser
        public var report: Report?

        public init(reportUser: ReportUser, report: Report? = nil) {
            self.reportUser = reportUser
            self.report = report
        }
    }
    
    public enum Action {
        case settingTapped
        case backButtonTapped
        case onAppear
        case fetchReportSuccess(Report)
        case handleError(Error)
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce(reducerCore)
    }
}

extension ReportFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return fetchReport(state: state)
        case .fetchReportSuccess(let report):
            state.report = report
            return .none
        case .handleError(let error):
            print(error)
            return .none
        case .backButtonTapped, .settingTapped:
            return .none
        }
    }

    func fetchReport(state: State) -> Effect<Action> {
        let userId = state.reportUser.userId
        return .run { send in
            do {
                let report = try await reportFetcherUseCase.fetch(userId: userId)
                await send(.fetchReportSuccess(report))
            } catch {
                await send(.handleError(error))
            }
        }
    }
}

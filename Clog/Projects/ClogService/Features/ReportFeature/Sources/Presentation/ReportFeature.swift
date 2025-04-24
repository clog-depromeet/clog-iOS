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
        public var report: Report = Report.init()
        public init() {}
    }
    
    public enum Action {
        case settingTapped
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
            return fetchReport()
        case .fetchReportSuccess(let report):
            state.report = report
            return .none
        case .handleError(let error):
            print(error)
            return .none
        default:
            return .none
        }
    }
    
    func fetchReport() -> Effect<Action> {
        .run { send in
            do {
                let report = try await reportFetcherUseCase.fetch()
                await send(.fetchReportSuccess(report))
            } catch {
                await send(.handleError(error))
            }
        }
    }
}

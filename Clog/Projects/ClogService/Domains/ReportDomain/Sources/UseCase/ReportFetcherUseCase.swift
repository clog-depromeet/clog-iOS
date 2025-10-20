//
//  ReportFetcherUseCase.swift
//  ReportDomain
//
//  Created by Junyoung on 3/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Dependencies
import Shared

public protocol ReportFetcherUseCase {
    func fetch(userId: String?) async throws -> Report
}

public struct ReportFetcher: ReportFetcherUseCase {
    private let repository: ReportRepository
    
    public init(repository: ReportRepository) {
        self.repository = repository
    }
    
    public func fetch(userId: String?) async throws -> Report {
        try await repository.fetch(userId: userId)
    }
}

// MARK: - Mock
public struct MockReportFetcher: ReportFetcherUseCase {
    public func fetch(userId: String?) async throws -> Report {
        return Report(
            userName: "",
            recentAttemptCount: 0,
            totalExerciseTime: TotalExerciseTime(
                totalExerciseTimeMs: 0
            ),
            totalAttemptCount: TotalAttemptCount(
                successAttemptCount: 0,
                totalAttemptCount: 0,
                completionRate: 0
            ),
            mostAttemptedProblem: MostAttemptedProblem(
                mostAttemptedProblemCrag: "",
                mostAttemptedProblemGrade: "",
                mostAttemptedProblemAttemptCount: 0,
                attemptVideos: []
            ),
            mostVisitedCrag: MostVisitedCrag(
                mostVisitedCragName: "",
                mostVisitedCragVisitCount: 0
            )
        )
    }
}

// MARK: - DependencyKey
public enum ReportFetcherDependencyKey: DependencyKey {
    public static var liveValue: any ReportFetcherUseCase = ClogDI.container.resolve(ReportFetcherUseCase.self)!
}

public extension DependencyValues {
    var reportFetcherUseCase: any ReportFetcherUseCase {
        get { self[ReportFetcherDependencyKey.self] }
        set { self[ReportFetcherDependencyKey.self] = newValue }
    }
}

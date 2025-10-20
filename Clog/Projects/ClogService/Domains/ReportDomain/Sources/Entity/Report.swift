//
//  Report.swift
//  ReportDomain
//
//  Created by Junyoung on 3/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

public struct Report: Equatable {
    public let userName: String
    public let recentAttemptCount: Int
    public let totalExerciseTime: TotalExerciseTime
    public let totalAttemptCount: TotalAttemptCount
    public let mostAttemptedProblem: MostAttemptedProblem?
    public let mostVisitedCrag: MostVisitedCrag?
    
    public init(
        userName: String,
        recentAttemptCount: Int,
        totalExerciseTime: TotalExerciseTime,
        totalAttemptCount: TotalAttemptCount,
        mostAttemptedProblem: MostAttemptedProblem?,
        mostVisitedCrag: MostVisitedCrag?
    ) {
        self.userName = userName
        self.recentAttemptCount = recentAttemptCount
        self.totalExerciseTime = totalExerciseTime
        self.totalAttemptCount = totalAttemptCount
        self.mostAttemptedProblem = mostAttemptedProblem
        self.mostVisitedCrag = mostVisitedCrag
    }
    
    public init() {
        self.userName = ""
        self.recentAttemptCount = 0
        self.totalExerciseTime = .init(totalExerciseTimeMs: 0)
        self.totalAttemptCount = .init(
            successAttemptCount: 0,
            totalAttemptCount: 0,
            completionRate: 0
        )
        self.mostAttemptedProblem = .init(
            mostAttemptedProblemCrag: "",
            mostAttemptedProblemGrade: "",
            mostAttemptedProblemAttemptCount: 0,
            attemptVideos: []
        )
        self.mostVisitedCrag = .init(mostVisitedCragName: "", mostVisitedCragVisitCount: 0)
    }
}

// MARK: - 운동 시간
public struct TotalExerciseTime: Equatable {
    public let totalExerciseTimeMs: Int
    
    public init(
        totalExerciseTimeMs: Int
    ) {
        self.totalExerciseTimeMs = totalExerciseTimeMs
    }
}

// MARK: - 시도 관련 통계
public struct TotalAttemptCount: Equatable {
    public let successAttemptCount: Int
    public let totalAttemptCount: Int
    public let completionRate: Int
    
    public init(
        successAttemptCount: Int,
        totalAttemptCount: Int,
        completionRate: Int
    ) {
        self.successAttemptCount = successAttemptCount
        self.totalAttemptCount = totalAttemptCount
        self.completionRate = completionRate
    }
}

// MARK: - 가장 많이 시도한 문제
public struct MostAttemptedProblem: Equatable {
    public let mostAttemptedProblemCrag: String?
    public let mostAttemptedProblemGrade: String?
    public let mostAttemptedProblemAttemptCount: Int
    public let attemptVideos: [AttemptVideo]
    
    public init(
        mostAttemptedProblemCrag: String?,
        mostAttemptedProblemGrade: String?,
        mostAttemptedProblemAttemptCount: Int,
        attemptVideos: [AttemptVideo]
    ) {
        self.mostAttemptedProblemCrag = mostAttemptedProblemCrag
        self.mostAttemptedProblemGrade = mostAttemptedProblemGrade
        self.mostAttemptedProblemAttemptCount = mostAttemptedProblemAttemptCount
        self.attemptVideos = attemptVideos
    }
}

public struct AttemptVideo: Equatable, Hashable {
    public let id: Int
    public let localPath: String
    public let thumbnailUrl: String?
    public let durationMs: Int
    
    public init(id: Int, localPath: String, thumbnailUrl: String?, durationMs: Int) {
        self.id = id
        self.localPath = localPath
        self.thumbnailUrl = thumbnailUrl
        self.durationMs = durationMs
    }
}

// MARK: - 가장 자주 방문한 암장
public struct MostVisitedCrag: Equatable {
    public let mostVisitedCragName: String
    public let mostVisitedCragVisitCount: Int
    
    public init(
        mostVisitedCragName: String,
        mostVisitedCragVisitCount: Int
    ) {
        self.mostVisitedCragName = mostVisitedCragName
        self.mostVisitedCragVisitCount = mostVisitedCragVisitCount
    }
}

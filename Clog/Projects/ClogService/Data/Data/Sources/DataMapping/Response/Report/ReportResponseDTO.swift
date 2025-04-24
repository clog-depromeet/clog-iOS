//
//  ReportResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ReportDomain

public struct ReportResponseDTO: Decodable {
    let userName: String?
    let recentAttemptCount: Int
    let totalExerciseTime: TotalExerciseTimeResponseDTO
    let totalAttemptCount: TotalAttemptCountResponseDTO
    let mostAttemptedProblem: MostAttemptedProblemResponseDTO?
    let mostVisitedCrag: MostVisitedCragResponseDTO?
    
    func toDomain() -> Report {
        return Report(
            userName: userName ?? "사용자", // 기본 값 "사용자"
            recentAttemptCount: recentAttemptCount,
            totalExerciseTime: totalExerciseTime.toDomain(),
            totalAttemptCount: totalAttemptCount.toDomain(),
            mostAttemptedProblem: mostAttemptedProblem?.toDomain(),
            mostVisitedCrag: mostVisitedCrag?.toDomain()
        )
    }
}

// MARK: - 운동 시간
public struct TotalExerciseTimeResponseDTO: Decodable {
    let totalExerciseTimeMs: Int
    
    func toDomain() -> TotalExerciseTime {
        return TotalExerciseTime(
            totalExerciseTimeMs: totalExerciseTimeMs
        )
    }
}

// MARK: - 시도 관련 통계
public struct TotalAttemptCountResponseDTO: Decodable {
    let successAttemptCount: Int
    let totalAttemptCount: Int
    let completionRate: Int
    
    func toDomain() -> TotalAttemptCount {
        return TotalAttemptCount(
            successAttemptCount: successAttemptCount,
            totalAttemptCount: totalAttemptCount,
            completionRate: completionRate
        )
    }
}

// MARK: - 가장 많이 시도한 문제
public struct MostAttemptedProblemResponseDTO: Decodable {
    let mostAttemptedProblemCrag: String?
    let mostAttemptedProblemGrade: String?
    let mostAttemptedProblemAttemptCount: Int
    let attemptVideos: [ReportAttemptVideoResponseDTO]
    
    func toDomain() -> MostAttemptedProblem {
        return MostAttemptedProblem(
            mostAttemptedProblemCrag: mostAttemptedProblemCrag,
            mostAttemptedProblemGrade: mostAttemptedProblemGrade,
            mostAttemptedProblemAttemptCount: mostAttemptedProblemAttemptCount,
            attemptVideos: attemptVideos.map { $0.toDomain() }
        )
    }
}

public struct ReportAttemptVideoResponseDTO: Decodable {
    let id: Int
    let localPath: String
    let thumbnailUrl: String?
    let durationMs: Int
    
    func toDomain() -> AttemptVideo {
        return AttemptVideo(
            id: id,
            localPath: localPath,
            thumbnailUrl: thumbnailUrl,
            durationMs: durationMs
        )
    }
}

// MARK: - 가장 자주 방문한 암장
public struct MostVisitedCragResponseDTO: Decodable {
    let mostVisitedCragName: String
    let mostVisitedCragVisitCount: Int
    
    func toDomain() -> MostVisitedCrag {
        return MostVisitedCrag(
            mostVisitedCragName: mostVisitedCragName,
            mostVisitedCragVisitCount: mostVisitedCragVisitCount
        )
    }
}

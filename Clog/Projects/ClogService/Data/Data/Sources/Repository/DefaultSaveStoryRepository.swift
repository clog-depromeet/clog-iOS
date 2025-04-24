//
//  DefaultSaveStoryRepository.swift
//  Data
//
//  Created by Junyoung on 3/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import VideoDomain

public struct DefaultSaveStoryRepository: SaveStoryRepository {
    private let dataSource: StoriesDataSource
    
    public init(dataSource: StoriesDataSource) {
        self.dataSource = dataSource
    }
    
    public func save(_ request: StoryRequest) async throws -> SavedStory {
        
        let request = StoryRequestDTO(
            cragId: request.cragId,
            problem: ProblemRequestDTO(gradeId: request.problem.gradeId),
            attempt: AttemptRequestDTO(
                status: request.attempt.status.rawValue,
                problemId: request.attempt.problemId,
                video: VideoRequestDTO(
                    localPath: request.attempt.video.localPath,
                    thumbnailUrl: request.attempt.video.thumbnailUrl,
                    durationMs: request.attempt.video.durationMs,
                    stamps: request.attempt.video.stamps.map { StampRequestDTO(timeMs: $0.timeMs) }
                )
            ),
            memo: request.memo
        )
        
        return try await dataSource.save(request).toDomain()
    }
}

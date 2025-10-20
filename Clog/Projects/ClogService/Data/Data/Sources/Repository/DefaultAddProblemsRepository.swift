//
//  DefaultAddProblemsRepository.swift
//  Data
//
//  Created by soi on 6/13/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import StoryDomain

public struct DefaultAddProblemsRepository: AddProblemsRepository {
    private let dataSource: StoriesDataSource
    
    public init(dataSource: StoriesDataSource) {
        self.dataSource = dataSource
    }
    
    public func execute(_ problems: AddProblems) async throws {
        let requestDTO = GalleryRequestDTO(
            date: problems.date,
            cragId: problems.cragId,
            memo: problems.memo,
            videos: problems.videos.map {
                .init(
                    localPath: $0.localPath,
                    thumbnailUrl: $0.thumbnailUrl,
                    durationMs: $0.durationMs,
                    stamps: [])
            }
        )
        return try await dataSource.gallery(requestDTO)
    }
}

//
//  DefaultSaveAttemptRepository.swift
//  Data
//
//  Created by Junyoung on 3/29/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import VideoDomain

public struct DefaultSaveAttemptRepository: SaveAttemptRepository {
    private let dataSource: AttemptDataSource
    
    public init(dataSource: AttemptDataSource) {
        self.dataSource = dataSource
    }
    
    public func register(_ request: AttemptRequest) async throws {
        
        let request = AttemptRequestDTO(
            status: request.status.rawValue,
            problemId: request.problemId,
            video: VideoRequestDTO(
                localPath: request.video.localPath,
                thumbnailUrl: request.video.thumbnailUrl,
                durationMs: request.video.durationMs,
                stamps: request.video.stamps.map { StampRequestDTO(timeMs: $0.timeMs) }
            )
        )
        
        return try await dataSource.register(request)
    }
}

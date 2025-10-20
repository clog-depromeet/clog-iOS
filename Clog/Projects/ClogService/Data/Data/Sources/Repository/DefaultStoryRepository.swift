//
//  DefaultStoryRepository.swift
//  Data
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import StoryDomain

public struct DefaultStoryRepository: StoryRepository {
    private let dataSource: StoriesDataSource
    
    public init(
        dataSource: StoriesDataSource
    ) {
        self.dataSource = dataSource
    }
    
    public func fetchSummary(_ storyId: Int) async throws -> StorySummary {
        try await dataSource.summary(storyId).toDomain()
    }
    
    public func fetchStory(_ storyId: Int) async throws -> Story {
        try await dataSource.stories(storyId).toDomain()
    }
    
    public func updateStatus(_ storyId: Int) async throws {
        try await dataSource.updateStatus(storyId)
    }
}

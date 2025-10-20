//
//  DefaultDeleteStoryRepository.swift
//  Data
//
//  Created by Junyoung on 3/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import StoryDomain

public struct DefaultDeleteStoryRepository: DeleteStoryRepository {
    private let dataSource: StoriesDataSource
    
    public init(
        dataSource: StoriesDataSource
    ) {
        self.dataSource = dataSource
    }
    
    public func execute(_ storyId: Int) async throws {
        try await dataSource.delete(storyId)
    }
}

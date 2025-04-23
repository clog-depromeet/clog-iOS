//
//  FetchStoryUseCase.swift
//  StoryDomain
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Dependencies
import Shared

public protocol FetchStoryUseCase {
    func fetchStory(_ storyId: Int) async throws-> Story
    func fetchSummary(_ storyId: Int) async throws -> StorySummary
}

public struct FetchStory: FetchStoryUseCase {
    private let repository: StoryRepository
    
    public init(repository: StoryRepository) {
        self.repository = repository
    }
    
    public func fetchStory(_ storyId: Int) async throws -> Story {
        try await repository.fetchStory(storyId)
    }
    
    public func fetchSummary(_ storyId: Int) async throws -> StorySummary {
        try await repository.fetchSummary(storyId)
    }
}

// MARK: - Mock
public struct MockFetchStory: FetchStoryUseCase {
    public func fetchStory(_ storyId: Int) async throws -> Story {
        return Story(
            id: 0,
            totalDurationMs: 0,
            problems: []
        )
    }
    
    public func fetchSummary(_ storyId: Int) async throws -> StorySummary {
        return StorySummary(
            id: 0,
            cragName: "",
            totalDurationMs: 0,
            totalAttemptsCount: 0,
            totalSuccessCount: 0,
            totalFailCount: 0,
            memo: "",
            problems: [],
            date: "",
            thumbnailUrl: nil
        )
    }
}

// MARK: - DependencyKey
public enum FetchCalendarDependencyKey: DependencyKey {
    public static var liveValue: any FetchStoryUseCase = ClogDI.container.resolve(FetchStoryUseCase.self)!
}

public extension DependencyValues {
    var fetchStoryUseCase: any FetchStoryUseCase {
        get { self[FetchCalendarDependencyKey.self] }
        set { self[FetchCalendarDependencyKey.self] = newValue }
    }
}

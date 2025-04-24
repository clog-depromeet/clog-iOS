//
//  SaveStoryUseCase.swift
//  StoryDomain
//
//  Created by Junyoung on 3/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Dependencies
import Shared

public enum SaveStoryError: Error {
    case unknown
}

public protocol SaveStoryUseCase {
    func execute(_ request: StoryRequest) async throws -> SavedStory
}

public struct SaveStory: SaveStoryUseCase {
    private let repository: SaveStoryRepository
    
    public init(repository: SaveStoryRepository) {
        self.repository = repository
    }
    
    public func execute(_ request: StoryRequest) async throws -> SavedStory {
        try await repository.save(request)
    }
}

// MARK: - Mock
public struct MockSaveStory: SaveStoryUseCase {
    public func execute(_ request: StoryRequest) async throws -> SavedStory {
        return SavedStory(storyId: 0, problemId: 0)
    }
}

// MARK: - DependencyKey
public enum SaveStoryDependencyKey: DependencyKey {
    public static var liveValue: any SaveStoryUseCase = ClogDI.container.resolve(SaveStoryUseCase.self)!
}

public extension DependencyValues {
    var saveStoryUseCase: any SaveStoryUseCase {
        get { self[SaveStoryDependencyKey.self] }
        set { self[SaveStoryDependencyKey.self] = newValue }
    }
}

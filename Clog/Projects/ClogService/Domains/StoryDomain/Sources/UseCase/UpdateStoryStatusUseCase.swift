//
//  UpdateStoryStatusUseCase.swift
//  StoryDomain
//
//  Created by Junyoung on 4/4/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Shared
import Dependencies

// MARK: - Interface
public protocol UpdateStoryStatusUseCase {
    func execute(_ storyId: Int) async throws
}

// MARK: - Implement
public struct UpdateStoryStatus: UpdateStoryStatusUseCase {
    private let repository: StoryRepository
    
    public init(repository: StoryRepository) {
        self.repository = repository
    }
    
    public func execute(_ storyId: Int) async throws {
        try await repository.updateStatus(storyId)
    }
}

// MARK: - DependencyKey
public enum UpdateStoryStatusDependencyKey: DependencyKey {
    public static var liveValue: any UpdateStoryStatusUseCase = ClogDI.container.resolve(UpdateStoryStatusUseCase.self)!
}

public extension DependencyValues {
    var updateStoryStatusUseCase: any UpdateStoryStatusUseCase {
        get { self[UpdateStoryStatusDependencyKey.self] }
        set { self[UpdateStoryStatusDependencyKey.self] = newValue }
    }
}

//
//  DeleteStoryUseCase.swift
//  StoryDomain
//
//  Created by Junyoung on 3/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Dependencies
import Shared

public protocol DeleteStoryUseCase {
    func execute(_ storyId: Int) async throws
}

public struct DeleteStory: DeleteStoryUseCase {
    private let repository: DeleteStoryRepository
    
    public init(repository: DeleteStoryRepository) {
        self.repository = repository
    }
    
    public func execute(_ storyId: Int) async throws {
        try await repository.execute(storyId)
    }
}

// MARK: - Mock
public struct MockDeleteStory: DeleteStoryUseCase {
    public func execute(_ storyId: Int) async throws {
        
    }
}

// MARK: - DependencyKey
public enum DeleteStoryDependencyKey: DependencyKey {
    public static var liveValue: any DeleteStoryUseCase = ClogDI.container.resolve(DeleteStoryUseCase.self)!
}

public extension DependencyValues {
    var deleteStoryUseCase: any DeleteStoryUseCase {
        get { self[DeleteStoryDependencyKey.self] }
        set { self[DeleteStoryDependencyKey.self] = newValue }
    }
}

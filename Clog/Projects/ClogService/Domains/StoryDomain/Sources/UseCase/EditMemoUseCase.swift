//
//  EditMemoUseCase.swift
//  StoryDomain
//
//  Created by Junyoung on 3/22/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Dependencies
import Shared

public protocol EditMemoUseCase {
    func execute(storyId: Int, memo: String) async throws
}

public struct EditMemo: EditMemoUseCase {
    private let repository: EditMemoRepository
    
    public init(repository: EditMemoRepository) {
        self.repository = repository
    }
    
    public func execute(storyId: Int, memo: String) async throws {
        try await repository.execute(storyId: storyId, memo: memo)
    }
}

// MARK: - Mock
public struct MockEditMemo: EditMemoUseCase {
    public func execute(storyId: Int, memo: String) async throws {
        
    }
}

// MARK: - DependencyKey
public enum EditMemoDependencyKey: DependencyKey {
    public static var liveValue: any EditMemoUseCase = ClogDI.container.resolve(EditMemoUseCase.self)!
}

public extension DependencyValues {
    var editMemoUseCase: any EditMemoUseCase {
        get { self[EditMemoDependencyKey.self] }
        set { self[EditMemoDependencyKey.self] = newValue }
    }
}

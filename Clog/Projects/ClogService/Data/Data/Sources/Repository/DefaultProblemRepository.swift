//
//  DefaultProblemRepository.swift
//  Data
//
//  Created by Junyoung on 3/30/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import StoryDomain

public struct DefaultProblemRepository: ProblemRepository {
    private let dataSource: StoriesDataSource
    
    public init(dataSource: StoriesDataSource) {
        self.dataSource = dataSource
    }
    
    public func execute(storyId: Int, gradeId: Int?) async throws -> Int {
        let request = RegisterProblemRequestDTO(storyId: storyId, body: GradeRequestDTO(gradeId: gradeId))
        return try await dataSource.problem(request).id
    }
}

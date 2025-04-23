//
//  ProblemRepository.swift
//  StoryDomain
//
//  Created by Junyoung on 3/30/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol ProblemRepository {
    func execute(storyId: Int, gradeId: Int?) async throws -> Int
}

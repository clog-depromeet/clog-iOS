//
//  SavedStory.swift
//  StoryDomain
//
//  Created by Junyoung on 3/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

public struct SavedStory: Equatable {
    public let storyId: Int
    public let problemId: Int
    
    public init(
        storyId: Int,
        problemId: Int
    ) {
        self.storyId = storyId
        self.problemId = problemId
    }
}

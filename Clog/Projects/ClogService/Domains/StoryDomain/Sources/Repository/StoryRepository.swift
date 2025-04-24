//
//  StoryRepository.swift
//  StoryDomain
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol StoryRepository {
    func fetchSummary(_ storyId: Int) async throws -> StorySummary
    func fetchStory(_ storyId: Int) async throws -> Story
    
    func updateStatus(_ storyId: Int) async throws
}

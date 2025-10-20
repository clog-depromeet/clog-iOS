//
//  SaveStoryRepository.swift
//  VideoDomain
//
//  Created by Junyoung on 3/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol SaveStoryRepository {
    func save(_ request: StoryRequest) async throws -> SavedStory
}

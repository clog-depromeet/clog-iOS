//
//  DeleteStoryRepository.swift
//  StoryDomain
//
//  Created by Junyoung on 3/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol DeleteStoryRepository {
    func execute(_ storyId: Int) async throws
}

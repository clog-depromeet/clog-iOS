//
//  SaveStoryResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import VideoDomain

public struct SaveStoryResponseDTO: Decodable {
    let storyId: Int
    let problemId: Int
    
    func toDomain() -> SavedStory {
        return SavedStory(
            storyId: storyId,
            problemId: problemId
        )
    }
}

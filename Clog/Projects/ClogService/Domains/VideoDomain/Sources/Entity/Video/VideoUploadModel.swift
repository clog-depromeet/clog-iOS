//
//  VideoUploadModel.swift
//  VideoDomain
//
//  Created by saeng lin on 3/22/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct VideoUploadModel: Codable {
    public let storyId: Int
    public let problemId: Int
    
    public init(storyId: Int, problemId: Int) {
        self.storyId = storyId
        self.problemId = problemId
    }
}

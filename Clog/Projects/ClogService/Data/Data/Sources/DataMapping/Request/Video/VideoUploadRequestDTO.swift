//
//  VideoRequestDTO.swift
//  Data
//
//  Created by saeng lin on 3/24/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct VideoUploadRequestDTO: Codable {
    public let cragId: Int
    public let problem: Problem
    public let attempt: Attempt
    public let memo: String
    
    public struct Problem: Codable {
        public let gradeId: Int
    }

    public struct Attempt: Codable {
        public let status: String
        public let problemId: Int
        public let video: Video
    }

    public struct Video: Codable {
        public let localPath: String
        public let thumbnailUrl: String?
        public let durationMs: Double
        public let stamps: [Stamp]
    }

    public struct Stamp: Codable {
        public let timeMs: Double
    }

}

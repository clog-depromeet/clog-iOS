//
//  StoryRequestDTO.swift
//  Data
//
//  Created by Junyoung on 3/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct StoryRequestDTO: Encodable {
    public let cragId: Int?
    public let problem: ProblemRequestDTO
    public let attempt: AttemptRequestDTO
    public let memo: String?
}

public struct ProblemRequestDTO: Encodable {
    public let gradeId: Int?
}

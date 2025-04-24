//
//  ProblemRequestDTO.swift
//  Data
//
//  Created by Junyoung on 3/30/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct RegisterProblemRequestDTO: Encodable {
    let storyId: Int
    let body: GradeRequestDTO
}

public struct GradeRequestDTO: Encodable {
    let gradeId: Int?
}

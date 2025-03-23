//
//  DetailAttemptResponseDTO.swift
//  Data
//
//  Created by soi on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import FolderDomain

public struct DetailAttemptResponseDTO: Decodable {
    let storyId: Int
    let problemId: Int
    let color: FolderAttemptColorResponseDTO?
    let crag: FolderCragResponseDTO?
    let attempt: AttemptResponseDTO
    
    func toDomain() -> ReadAttempt {
        ReadAttempt(
            storyId: storyId,
            problemId: problemId,
            date: "", // TODO: FIXME
            grade: color?.toDomain(),
            crag: crag?.toDomain(),
            result: AttemptResult(rawValue: attempt.status) ?? .complete,
            attempt: attempt.toDomain()
        )
    }
}

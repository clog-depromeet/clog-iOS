//
//  FolderAttemptResponseDTO.swift
//  Data
//
//  Created by soi on 3/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import FolderDomain
import Shared

public struct FolderAttemptResponseDTO: Decodable {
    let attemptId: Int
    let date: String
    let video: FolderVideoResponseDTO
    let crag: FolderCragResponseDTO?
    let color: FolderAttemptColorResponseDTO?
    let status: String
    
    func toDomain() -> Attempt {
        Attempt(
            id: attemptId,
            date: date,
            grade: color?.toDomain(),
            result: AttemptResult(rawValue: status) ?? .complete,
            thumbnailUrl: video.thumbnailUrl,
            recordedTime: video.durationMs.msToTimeString,
            crag: crag?.toDomain()
        )
    }
}

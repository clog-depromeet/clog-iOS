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
    let crag: FolderAttemptCragResponseDTO?
    let color: FolderAttemptColorResponseDTO?
    let status: String
    
    func toDomain() -> Attempt {
        Attempt(
            date: date,
            grade: color?.toDomain(),
            result: AttemptResult(rawValue: status) ?? .complete,
            recordedTime: video.durationMs.msToTimeString,
            crag: crag?.toDomain()
        )
    }
}

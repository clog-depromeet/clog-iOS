//
//  ProblemResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import CalendarDomain

public struct ProblemResponseDTO: Decodable {
    let id: Int
    let attemptCount: Int
    let colorHex: String
    
    func toDomain() -> ClimbProblem {
        return ClimbProblem(
            id: id,
            attemptCount: attemptCount,
            colorHex: colorHex
        )
    }
}

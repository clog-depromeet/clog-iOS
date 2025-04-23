//
//  ProblemResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import CalendarDomain

public struct CalendarProblemResponseDTO: Decodable {
    let count: Int
    let colorHex: String?
    
    func toDomain() -> CalendarProblem {
        return CalendarProblem(
            attemptCount: count,
            colorHex: colorHex ?? ""
        )
    }
}

//
//  GradeResponseDTO.swift
//  Data
//
//  Created by soi on 3/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public struct GradeResponseDTO: Decodable {
    public let gradeId: Int
    let order: Int
    let color: ColorResponseDTO
    
    func toDomain() -> Grade {
        Grade(
            id: gradeId,
            name: color.name,
            hexCode: color.hex
        )
    }
}

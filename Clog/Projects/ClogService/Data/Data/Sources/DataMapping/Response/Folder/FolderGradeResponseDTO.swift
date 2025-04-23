//
//  FolderGradeResponseDTO.swift
//  Data
//
//  Created by soi on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public struct FolderGradeResponseDTO: Decodable {
    let gradeId: Int
    let colorName: String
    let colorHex: String
    
    func toDomain() -> Grade {
        Grade(
            id: gradeId,
            name: colorName,
            hexCode: colorHex
        )
    }
}

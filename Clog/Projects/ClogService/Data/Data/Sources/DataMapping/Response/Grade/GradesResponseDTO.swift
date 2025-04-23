//
//  GradesResponseDTO.swift
//  Data
//
//  Created by soi on 3/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct GradesResponseDTO: Decodable {
    let grades: [GradeResponseDTO]
}

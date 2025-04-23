//
//  FolderAttemptColorResponseDTO.swift
//  Data
//
//  Created by soi on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

struct FolderAttemptColorResponseDTO: Decodable {
    let id: Int
    let hex: String
    let name: String
    
    func toDomain() -> Grade {
        Grade(
            id: id,
            name: name,
            hexCode: hex
        )
    }
}

//
//  AttemptStampResponseDTO.swift
//  Data
//
//  Created by soi on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import FolderDomain

struct AttemptStampResponseDTO: Decodable {
    let id: Int
    let timeMs: Int
    
    func toDomain(durationMs: Int) -> AttemptStamp {
        let position = durationMs > 0 ? Float(timeMs / durationMs) : 0
        return AttemptStamp(
            id: id,
            timeMs: timeMs,
            position: position
        )
    }
}

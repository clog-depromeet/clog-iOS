//
//  FolderCragResponseDTO.swift
//  Data
//
//  Created by soi on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public struct FolderCragResponseDTO: Decodable {
    let id: Int
    let name: String
    let roadAddress: String
    
    func toDomain() -> Crag {
        Crag(
            id: id,
            name: name,
            address: roadAddress
        )
    }
}

//
//  MetaResponseDTO.swift
//  Data
//
//  Created by soi on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
struct BaseMetaResponseDTO: Decodable {
    let nextCursor: Int
    let hasMore: Bool
}

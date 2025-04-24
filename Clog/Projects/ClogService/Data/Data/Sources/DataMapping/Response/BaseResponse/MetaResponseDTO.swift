//
//  MetaResponseDTO.swift
//  Data
//
//  Created by soi on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
public struct BaseMetaResponseDTO: Decodable {
    public let nextCursor: Double?
    public let hasMore: Bool
}

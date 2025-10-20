//
//  FolderVideoResponseDTO.swift
//  Data
//
//  Created by soi on 3/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import FolderDomain

struct FolderVideoResponseDTO: Decodable {
    let id: Int
    let localPath: String
    let thumbnailUrl: String?
    let durationMs: Int
}

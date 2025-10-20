//
//  AttemptPatchRequestDTO.swift
//  Data
//
//  Created by soi on 3/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import FolderDomain

public struct AttemptPatchRequestDTO: Encodable {
    let cragId: Int?
    let gradeId: Int?
    let gradeUnregistered: Bool?
    let status: String?
    
    public init(
        cragId: Int? = nil,
        gradeId: Int? = nil,
        gradeUnregistered: Bool? = nil,
        status: String? = nil
    ) {
        self.cragId = cragId
        self.gradeId = gradeId
        self.gradeUnregistered = gradeUnregistered
        self.status = status
    }
}


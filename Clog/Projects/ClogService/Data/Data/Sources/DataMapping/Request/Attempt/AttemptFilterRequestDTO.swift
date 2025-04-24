//
//  AttemptFilterRequestDTO.swift
//  Data
//
//  Created by soi on 3/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct AttemptFilterRequestDTO: Encodable {
    let attemptStatus: String?
    let cragId: Int?
    let gradeId: Int?
    
    public init(attemptStatus: String?, cragId: Int?, gradeId: Int?) {
        self.attemptStatus = attemptStatus
        self.cragId = cragId
        self.gradeId = gradeId
    }
}

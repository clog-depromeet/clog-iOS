//
//  StampRequest.swift
//  Shared
//
//  Created by soi on 7/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct StampRequest {
    public let timeMs: Int
    
    public init(
        timeMs: Int
    ) {
        self.timeMs = timeMs
    }
}

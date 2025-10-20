//
//  AttemptStamp.swift
//  FolderDomain
//
//  Created by soi on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct AttemptStamp: Hashable, Equatable {
    public let id: Int
    public let timeMs: Int
    public let position: Float
    
    public init(
        id: Int,
        timeMs: Int,
        position: Float
    ) {
        self.id = id
        self.timeMs = timeMs
        self.position = position
    }
}

//
//  Grade.swift
//  Shared
//
//  Created by soi on 3/10/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct Grade: Hashable, Identifiable {
    public let id: Int
    public let name: String
    public let hexCode: String
    
    public init(id: Int, name: String, hexCode: String) {
        self.id = id
        self.name = name
        self.hexCode = hexCode
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

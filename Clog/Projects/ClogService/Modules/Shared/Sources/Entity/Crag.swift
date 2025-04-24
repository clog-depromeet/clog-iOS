//
//  Crag.swift
//  Shared
//
//  Created by soi on 3/10/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct Crag: Hashable, Identifiable {
    public var id: Int
    
    public let name: String
    public let address: String
    
    public init(id: Int, name: String, address: String) {
        self.id = id
        self.name = name
        self.address = address
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

//
//  Header.swift
//  Starlink
//
//  Created by saeng lin on 2/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public extension Starlink {
    
    struct Header: Sendable , Hashable {
        public let name: String
        public let value: String
        
        public init(name: String, value: String) {
            self.name = name
            self.value = value
        }
    }
}

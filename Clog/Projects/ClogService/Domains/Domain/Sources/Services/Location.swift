//
//  Location.swift
//  Domain
//
//  Created by soi on 4/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct Location: Equatable {
    let latitude: Double
    let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

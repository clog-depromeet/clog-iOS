//
//  Stamp.swift
//  EditDomain
//
//  Created by seunghwan Lee on 3/29/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct Stamp: Identifiable, Equatable {
    public let id: UUID
    public let time: Double
    public let xPos: CGFloat
    public let isValid: Bool

    public init(time: Double, xPos: CGFloat, isValid: Bool) {
        self.id = UUID()
        self.time = time
        self.xPos = xPos
        self.isValid = isValid
    }
    
    public init(time: Double, stampAreaWidth: CGFloat, videoDuration: TimeInterval) {
        let xPos = (time / videoDuration) * Double(stampAreaWidth)
        self.id = UUID()
        self.time = time
        self.xPos = xPos
        self.isValid = true
    }
    
    public static func == (lhs: Stamp, rhs: Stamp) -> Bool {
        lhs.id == rhs.id
    }
}

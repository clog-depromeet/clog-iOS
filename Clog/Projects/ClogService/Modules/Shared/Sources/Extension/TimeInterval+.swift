//
//  TimeInterval+.swift
//  Shared
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

extension TimeInterval {
    // 0.1로 단위로 된 TimeInterval 계산
    public func formatTimeInterval() -> String {
        let totalCentiseconds = Int(self)
        let seconds = (totalCentiseconds % 6000) / 100
        let minutes = (totalCentiseconds / 6000) % 60
        let hours = totalCentiseconds / 360000
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

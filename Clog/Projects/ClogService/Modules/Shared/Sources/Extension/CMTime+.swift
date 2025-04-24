//
//  CMTime+.swift
//  Shared
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import AVFoundation

extension CMTime {
    public func formatTimeInterval() -> String {
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

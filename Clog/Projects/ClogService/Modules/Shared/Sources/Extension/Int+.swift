//
//  Int+.swift
//  Shared
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public extension Int {
    var msToTimeString: String {
        /// 밀리초(ms)를 `HH:mm:ss` 포맷으로 변환
        let totalSeconds = self / 1000
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

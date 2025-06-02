//
//  VideoAssetMetadata.swift
//  Core
//
//  Created by soi on 5/27/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct VideoAssetMetadata: Equatable, Identifiable {
    public let id = UUID()
    public let url: URL
    public let duration: TimeInterval
    public let creationDate: Date?
    
    public var formattedDuration: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = duration >= 3600 ? [.hour, .minute, .second] : [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: duration) ?? "00:00"
    }
}

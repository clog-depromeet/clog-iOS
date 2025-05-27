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
}

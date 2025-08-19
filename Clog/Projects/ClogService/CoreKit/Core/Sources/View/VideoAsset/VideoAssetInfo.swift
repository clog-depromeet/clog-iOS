//
//  VideoAssetInfo.swift
//  Core
//
//  Created by soi on 7/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import AVFoundation
import _PhotosUI_SwiftUI

public struct VideoInfo: Equatable, Identifiable {
    public let id: String
    public let phAssetId: String?
    public let thumbnail: UIImage?
    public let duration: Double
    public let formattedDuration: String
    public let creationDate: Date?
    
    public init(
        id: String = UUID().uuidString,
        phAssetId: String?,
        thumbnail: UIImage?,
        duration: Double,
        creationDate: Date?
    ) {
        self.id = id
        self.phAssetId = phAssetId
        self.thumbnail = thumbnail
        self.duration = duration
        self.formattedDuration = Self.formatDuration(duration)
        self.creationDate = creationDate
    }
    
    private static func formatDuration(_ seconds: Double) -> String {
        let hours = Int(seconds) / 3600
        let minutes = Int(seconds) % 3600 / 60
        let remainingSeconds = Int(seconds) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, remainingSeconds)
        } else {
            return String(format: "%d:%02d", minutes, remainingSeconds)
        }
    }
    
    static public func make(from url: URL, assetId: String?) async throws -> VideoInfo {
        let asset = AVAsset(url: url)
        let duration = try await asset.load(.duration)
        let durationSeconds = CMTimeGetSeconds(duration)
        let creationDate = try? await asset.load(.creationDate)?.startDate
        let thumbnail = try await asset.generateThumbnail()
        
        return VideoInfo(
            id: UUID().uuidString,
            phAssetId: assetId,
            thumbnail: thumbnail,
            duration: durationSeconds,
            creationDate: creationDate
        )
    }
}

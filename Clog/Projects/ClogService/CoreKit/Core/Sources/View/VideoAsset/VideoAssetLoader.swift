//
//  VideoAssetLoader.swift
//  Core
//
//  Created by soi on 5/27/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import _PhotosUI_SwiftUI

public enum VideoAssetLoader {
    public static func loadVideoMetadata(from item: PhotosPickerItem) async throws -> VideoAssetMetadata? {
        guard let data = try? await item.loadTransferable(type: Data.self) else {
            return nil
        }
        let tempURL = try writeToTemporaryFile(data: data, fileExtension: "mov")
        return try await extractMetadata(from: tempURL)
    }
    
    private static func writeToTemporaryFile(data: Data, fileExtension: String) throws -> URL {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(fileExtension)
        try data.write(to: url)
        return url
    }
    
    private static func extractMetadata(from url: URL) async throws -> VideoAssetMetadata {
        
        let asset = AVAsset(url: url)
        let duration = try await asset.load(.duration)
        let startDate = try? await asset.load(.creationDate)?.startDate
        
        return VideoAssetMetadata(
            url: url,
            duration: duration.seconds,
            creationDate: startDate
        )
    }
}

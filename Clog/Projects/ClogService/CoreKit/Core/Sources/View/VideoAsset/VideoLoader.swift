//
//  VideoLoader.swift
//  Core
//
//  Created by soi on 7/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import _PhotosUI_SwiftUI

public enum VideoLoader {
    public static func loadVideoInfo(from item: PhotosPickerItem) async throws -> VideoInfo? {
        guard let data = try await item.loadTransferable(type: Data.self) else {
            return nil
        }
        
        let tempURL = try writeToTemporaryFile(data: data, fileExtension: "mov")
        
        defer {
            try? FileManager.default.removeItem(at: tempURL)
        }
        
        return try await VideoInfo.make(from: tempURL, assetId: item.itemIdentifier)
    }
    
    private static func writeToTemporaryFile(data: Data, fileExtension: String) throws -> URL {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(fileExtension)
        try data.write(to: url)
        return url
    }
}

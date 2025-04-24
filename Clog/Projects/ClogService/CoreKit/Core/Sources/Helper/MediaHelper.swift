//
//  MediaHelper.swift
//  Core
//
//  Created by soi on 3/29/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared
import Photos

public enum MediaUtilityError: Error {
    case notFound
}

public enum MediaUtility {
    public static func getURL(fromAssetID assetID: String) async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            PHAsset.getURL(fromAssetID: assetID) { url in
                if let url  {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(throwing: MediaUtilityError.notFound)
                }
            }
        }
    }
}

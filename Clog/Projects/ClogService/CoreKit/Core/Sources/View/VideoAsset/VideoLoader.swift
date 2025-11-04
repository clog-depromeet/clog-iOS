//
//  VideoLoader.swift
//  Core
//
//  Created by soi on 7/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Photos
import _PhotosUI_SwiftUI
import AVFoundation
import UIKit

public enum VideoLoader {
    public static func loadVideoInfo(from item: PhotosPickerItem) async throws -> VideoInfo? {
        guard let assetId = item.itemIdentifier else { return nil }
        
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
        
        guard let phAsset = fetchResult.firstObject, phAsset.mediaType == .video else { return nil }
        
        let duration = try await loadDuration(for: phAsset)
        let thumbnail = try await generateThumbnail(for: phAsset)
        let creationDate = phAsset.creationDate
        
        return VideoInfo(
            id: UUID().uuidString,
            phAssetId: assetId,
            thumbnail: thumbnail,
            duration: duration,
            creationDate: creationDate
        )
    }
    
    private static func loadDuration(for asset: PHAsset) async throws -> TimeInterval {
        let avAsset = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<AVAsset, Error>) in
            let options = PHVideoRequestOptions()
            options.isNetworkAccessAllowed = true
            options.deliveryMode = .fastFormat
            
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, info in
                if let error = info?[PHImageErrorKey] as? Error {
                    continuation.resume(throwing: error)
                } else if let avAsset = avAsset {
                    continuation.resume(returning: avAsset)
                } else {
                    continuation.resume(throwing: NSError(domain: "VideoLoader", code: -1))
                }
            }
        }
        
        let duration = try await avAsset.load(.duration)
        return CMTimeGetSeconds(duration)
    }
    
    private static func generateThumbnail(for asset: PHAsset) async throws -> UIImage? {
        return try await withCheckedThrowingContinuation { continuation in
            let imageManager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = false
            options.isNetworkAccessAllowed = true
            
            let targetSize = CGSize(width: 300, height: 300)
            
            imageManager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFill,
                options: options
            ) { image, info in
                if let error = info?[PHImageErrorKey] as? Error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: image)
                }
            }
        }
    }
}

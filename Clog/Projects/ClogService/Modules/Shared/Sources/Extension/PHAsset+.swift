//
//  PHAsset+.swift
//  Shared
//
//  Created by soi on 3/29/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Photos

extension PHAsset {
    static public func getURL(fromAssetID assetID: String, completion: @escaping (URL?) -> Void) {
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetID], options: nil)
        guard let asset = fetchResult.firstObject else {
            completion(nil)
            return
        }
        
        asset.getURL(completion: completion)
    }
    
    private func getURL(completion: @escaping (URL?) -> Void) {
        if self.mediaType == .video {
            let options = PHVideoRequestOptions()
            options.version = .original
            
            PHImageManager.default().requestAVAsset(forVideo: self, options: options) { avAsset, _, _ in
                if let urlAsset = avAsset as? AVURLAsset {
                    completion(urlAsset.url)
                } else {
                    completion(nil)
                }
            }
        } else if self.mediaType == .image {
            let options = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = { _ in true }
            
            self.requestContentEditingInput(with: options) { contentEditingInput, _ in
                completion(contentEditingInput?.fullSizeImageURL)
            }
        } else {
            completion(nil)
        }
    }
}

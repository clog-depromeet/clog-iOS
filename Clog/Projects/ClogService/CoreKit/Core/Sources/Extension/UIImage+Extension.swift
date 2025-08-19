//
//  UIImage+Extension.swift
//  Core
//
//  Created by soi on 7/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

extension UIImage {
    public func resizedPNGData(targetSizeInBytes: Int = 1_000_000) -> Data? {
        guard var currentData = self.pngData() else { return nil }
        
        // 이미지의 해상도를 줄여서 targetSizeInBytes 미만이 될 때까지 반복
        var currentImage = self
        let scaleFactor: CGFloat = 0.9
        
        while currentData.count > targetSizeInBytes,
              currentImage.size.width > 100, currentImage.size.height > 100 {
            let newSize = CGSize(width: currentImage.size.width * scaleFactor,
                                 height: currentImage.size.height * scaleFactor)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            currentImage.draw(in: CGRect(origin: .zero, size: newSize))
            guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
                UIGraphicsEndImageContext()
                break
            }
            UIGraphicsEndImageContext()
            
            currentImage = resizedImage
            if let data = currentImage.pngData() {
                currentData = data
            } else {
                break
            }
        }
        
        return currentData.count <= targetSizeInBytes ? currentData : nil
    }
}

import AVFoundation
import UIKit

// TODO: 삭제 가능 여부,,,
public extension AVAsset {
    func generateThumbnail(
        maxSize: CGSize = CGSize(width: 300, height: 300)
    ) async throws -> UIImage {
        let imageGenerator = AVAssetImageGenerator(asset: self)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.maximumSize = maxSize
        let cgImage = try await imageGenerator.image(at: .zero).image
        return UIImage(cgImage: cgImage)
    }
}

//
//  ThumbnailsView.swift
//  EditFeature
//
//  Created by seunghwan Lee on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import AVKit

/// 편집 섬네일 컷 (10장)
struct ThumbnailsView: View {
    let asset: AVAsset
    let duration: Double
    let thumbnailSize: CGSize
    let thumbnailCount: Int
    
    init(asset: AVAsset, duration: Double, frameSize: CGSize) {
        self.thumbnailCount = 10
        self.asset = asset
        self.duration = duration
        self.thumbnailSize = CGSize(width: frameSize.width / CGFloat(thumbnailCount), height: frameSize.height)
    }
    
    @State private var thumbnails: [UIImage] = []
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(thumbnails.indices, id: \.self) { index in
                Image(uiImage: thumbnails[index])
                    .resizable()
                    .frame(width: thumbnailSize.width, height: thumbnailSize.height)
                    .aspectRatio(contentMode: .fill)
            }
        }
        .onAppear {
            generateThumbnails()
        }
    }
    
    private func generateThumbnails() {
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
         
        Task {
            let assetDuration = try await asset.load(.duration)
            let durationSeconds = assetDuration.seconds
            
            let cmTimes = Array(0..<thumbnailCount).map { i in
                let time = durationSeconds * Double(i) / Double(thumbnailCount)
                return CMTime(seconds: time, preferredTimescale: 600)
            }
            var thumbnails: [UIImage] = []
            for await imageResult in generator.images(for: cmTimes) {
                if let image = try? imageResult.image {
                    thumbnails.append(UIImage(cgImage: image))
                }
            }
            
            await MainActor.run {
                self.thumbnails = thumbnails
            }
        }
    }
}

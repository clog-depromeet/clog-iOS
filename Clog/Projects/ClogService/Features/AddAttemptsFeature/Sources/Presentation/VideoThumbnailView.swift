//
//  VideoThumbnailView.swift
//  AddAttemptsFeature
//
//  Created by soi on 5/27/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import AVFoundation

struct VideoThumbnailView: View {
    let url: URL
    let duration: TimeInterval

    @State private var thumbnail: UIImage?

    var body: some View {
        VStack {
            if let thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
            } else {
                ProgressView()
            }
            Text("길이: \(Int(duration))초")
        }
        .task {
            thumbnail = generateVideoThumbnail(from: url)
        }
    }

    func generateVideoThumbnail(from url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 1, preferredTimescale: 600)
        if let cgImage = try? generator.copyCGImage(at: time, actualTime: nil) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
}

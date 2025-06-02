//
//  VideoThumbnailView.swift
//  AddAttemptsFeature
//
//  Created by soi on 5/27/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import AVFoundation

import DesignKit

struct VideoThumbnailView: View {
    let url: URL
    let timeString: String
    let size: CGFloat

    @State private var thumbnail: UIImage?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.clogUI.gray600)
                if let thumbnail {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .scaledToFill()
                } else {
                    ProgressView()
                        .frame(width: 60, height: 60)
                }
            }
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(timeString)
                .font(.c1)
                .foregroundStyle(Color.clogUI.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color.clogUI.gray700.opacity(0.7))
                )
                .padding([.trailing, .top], 8)
            
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

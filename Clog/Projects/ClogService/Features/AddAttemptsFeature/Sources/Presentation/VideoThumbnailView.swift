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

public struct VideoThumbnailView: View {
    let image: UIImage?
    let duration: String?
    let size: CGFloat
    
    public init(
        image: UIImage?,
        duration: String?,
        size: CGFloat
    ) {
        self.image = image
        self.duration = duration
        self.size = size
    }
    
    public var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.clogUI.gray600)
                
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    ProgressView()
                        .frame(width: 60, height: 60)
                }
            }
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            if let duration {
                Text(duration)
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
        }
    }
}

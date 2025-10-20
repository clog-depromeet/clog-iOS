//
//  PlayerProgressBar.swift
//  DesignKit
//
//  Created by soi on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

struct Stamp: Identifiable {
    let id: Double
    let time: Double
    let xPos: CGFloat

    init(time: Double, xPos: CGFloat) {
        self.id = time
        self.time = time
        self.xPos = xPos
    }
}

public struct PlayerProgressBar: View {
    private enum Constnats {
        static let stampYOffset: CGFloat = -3
    }
    
    private let width: CGFloat
    private let progress: CGFloat
    private let stamps: [Stamp]
    private let onStampTapped: ((Double) -> Void)?
    
    public init(
        width: CGFloat = UIScreen.main.bounds.width,
        duration: Double,
        progress: CGFloat,
        stampTimeList: [Double] = [],
        onStampTapped: ((Double) -> Void)?
    ) {
        self.width = width
        self.progress = progress.isNaN ? 0 : progress
        self.stamps = stampTimeList.map {
            let xPos = ($0 / duration) * width
            return Stamp(time: $0, xPos: xPos)
        }
        self.onStampTapped = onStampTapped
    }
    
    private var stampArea: some View {
        Color.clear
            .frame(height: 15)
            .overlay {
                ForEach(stamps) { stamp in
                    Image.clogUI.stamp
                        .foregroundStyle(Color.clogUI.primary)
                        .position(x: stamp.xPos, y: Constnats.stampYOffset)
                        .onTapGesture {
                            onStampTapped?(stamp.time)
                        }
                }
            }
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            stampArea
            
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    Color.clogUI.primary
                        .frame(width: geometry.size.width * min(progress, 1.0))
                    
                    Color.clogUI.gray50
                        .frame(maxWidth: .infinity)
                }
                .overlay {
                    ForEach(stamps) { stamp in
                        Rectangle()
                            .fill(Color.clogUI.gray900)
                            .frame(width: 1)
                            .position(x: stamp.xPos, y: geometry.size.height / 2)
                    }
                }
            }
            .frame(height: 5)
        }
    }
}

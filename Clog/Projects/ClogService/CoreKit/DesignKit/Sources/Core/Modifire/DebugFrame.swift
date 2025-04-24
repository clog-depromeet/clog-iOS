//
//  debugFrame.swift
//  DesignKit
//
//  Created by saeng lin on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

extension View {
    public func debugFrameSize(
        color: Color = .randomeColor()
    ) -> some View {
        modifier(FrameSize(color: color))
    }
}

private struct FrameSize: ViewModifier {
    var color: Color

    func body(content: Content) -> some View {
        content
        #if DEBUG
            .overlay(GeometryReader(content: overlay(for:)))
        #endif
    }

    func overlay(for geometry: GeometryProxy) -> some View {
        ZStack(
            alignment: Alignment(horizontal: .trailing, vertical: .top)
        ) {
            Rectangle()
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(color)
            Text("\(Int(geometry.size.width))x\(Int(geometry.size.height))")
                .font(.footnote)
                .foregroundColor(color)
                .padding(2)
        }
    }
}

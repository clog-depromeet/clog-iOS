//
//  DragEditView.swift
//  EditFeature
//
//  Created by seunghwan Lee on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import DesignKit

/// 편집 > 하단 드래그 편집 핸들링 영역
public struct DragEditView: View {
    @Binding var leftPosition: CGFloat
    @Binding var rightPosition: CGFloat
    let frameSize: CGSize
    
    public var body: some View {
        HStack(spacing: 0) {
            // 편집 제외된 영역
            Color.black.opacity(0.6)
                .frame(width: leftPosition)

            // 편집 영역
            Color.clear
                .border(Color.clogUI.primary, width: 3)
                .frame(maxWidth: .infinity)

            // 편집 제외된 영역
            Color.black.opacity(0.6)
                .frame(width: max(0, frameSize.width - rightPosition))
        }
        
        DragHandleView(type: .left)
            .position(x: leftPosition - DragHandleView.Constants.handleHalfWidth, y: frameSize.height / 2)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        leftPosition = max(0, min(rightPosition, value.location.x))
                    }
            )

        DragHandleView(type: .right)
            .position(x: rightPosition + DragHandleView.Constants.handleHalfWidth, y: frameSize.height / 2)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        rightPosition = min(max(leftPosition, value.location.x), frameSize.width)
                    }
            )
    }
}

struct DragHandleView: View {
    enum Constants {
        static let handleWidth: CGFloat = 21
        static let handleHalfWidth: CGFloat = 10.5
    }
    
    enum handleType {
        case left
        case right
        
        var image: Image {
            switch self {
            case .left:
                Image.clogUI.back
            case .right:
                Image.clogUI.right
            }
        }
    }
    
    let type: handleType
    
    var body: some View {
        type.image
            .frame(width: Constants.handleWidth)
            .frame(maxHeight: .infinity)
            .background(Color.clogUI.primary)
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: type == .left ? 8 : 0,
                    bottomLeadingRadius: type == .left ? 8 : 0,
                    bottomTrailingRadius: type == .left ? 0 : 8,
                    topTrailingRadius: type == .left ? 0 : 8
                )
            )
    }
}

//
//  VideoPreview.swift
//  VideoFeature
//
//  Created by lin.saeng on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

// 카메라만 보여지는 Preview
public struct VideoPreview: UIViewRepresentable {
    
    @ObservedObject var camera: VideoPreviewViewModel
    
    public init(camera: VideoPreviewViewModel) {
        self.camera = camera
    }
    
    public func makeUIView(context contenxt: Context) -> UIView {
        return VideoSession(camera: camera)
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {}
}


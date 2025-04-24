//
//  VideoSession.swift
//  VideoFeature
//
//  Created by saeng lin on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

// Apple Module
import UIKit
import AVFoundation

public class VideoSession: UIView {
    
    private var previewLayer: AVCaptureVideoPreviewLayer
    
    private var camera: VideoPreviewViewModel
    
    init(camera: VideoPreviewViewModel) {
        self.camera = camera
        self.previewLayer = AVCaptureVideoPreviewLayer(session: camera.session)
        super.init(frame: UIScreen.main.bounds)
        configure()
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
    }
    
    private func configure() {
        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)
    }
}

//
//  RecordingPlayView.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit
import AVFoundation

public class RecordingPlayView: UIView {
    
    private var previewLayer: AVCaptureVideoPreviewLayer
    private let viewModel: RecordingPlayViewModel
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit: \(Self.self)")
    }
    
    public init(viewModel: RecordingPlayViewModel) {
        self.viewModel = viewModel
        self.previewLayer = AVCaptureVideoPreviewLayer(session: viewModel.session)
        super.init(frame: UIScreen.main.bounds)
        
        configure()
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

//
//  RecordingPlyPreView.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct RecordingPlyPreview: UIViewRepresentable {
    
    @ObservedObject
    private var viewModel: RecordingPlayViewModel
    
    init(viewModel: RecordingPlayViewModel) {
        self.viewModel = viewModel
    }
    
    public func makeUIView(context: Context) -> RecordingPlayView {
        return RecordingPlayView(viewModel: viewModel)
    }
    
    public func updateUIView(_ uiView: RecordingPlayView, context: Context) {
        
    }
}

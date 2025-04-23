//
//  RecordedPlayPreview.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct RecordedPlayPreview: UIViewRepresentable {
    
    @ObservedObject
    private var viewModel: RecordedPlayViewModel
    
    init(viewModel: RecordedPlayViewModel) {
        self.viewModel = viewModel
    }
    
    public func makeUIView(context: Context) -> RecordedPlayView {
        return RecordedPlayView(frame: UIScreen.main.bounds, viewModel: viewModel)
    }
    
    public func updateUIView(_ uiView: RecordedPlayView, context: Context) {}
}

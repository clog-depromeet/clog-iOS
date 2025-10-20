//
//  RecordedPlayView.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit
import AVFoundation
import Combine

extension AVPlayer: RecordedPlayerable {}

public class RecordedPlayView: UIView {
    private let viewModel: RecordedPlayViewModel
    private var player: AVPlayer
    
    private let sessionQueue = DispatchQueue(label: "RecordingPlay.Session.Queue")
    private var bag = Set<AnyCancellable>()
    
    init(frame: CGRect = .zero, viewModel: RecordedPlayViewModel) {
        self.viewModel = viewModel
        self.player = AVPlayer(url: viewModel.videoURL.value)
        super.init(frame: frame)
        bind()
        self.viewModel.configurePlayer(with: player)
        setupPlayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.frame = bounds
    }
    
    public override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    private func setupPlayer() {
        if let playerLayer = self.layer as? AVPlayerLayer {
            playerLayer.player = player
            playerLayer.videoGravity = .resizeAspectFill
        }
    }
    
    private func bind() {
        viewModel.videoURL
            .removeDuplicates()
            .sink { [weak self] url in
                guard let self else { return }
                self.player.replaceCurrentItem(with: AVPlayerItem(url: url))
                self.player.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero)
            }
            .store(in: &bag)
    }
}



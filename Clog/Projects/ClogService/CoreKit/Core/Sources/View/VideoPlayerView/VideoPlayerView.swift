//
//  VideoPlayerView.swift
//  Core
//
//  Created by soi on 3/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import AVKit
import Photos

public struct VideoPlayerView: UIViewRepresentable {
    private let player: AVPlayer
    @Binding private var playbackState: Bool
    @Binding private var playbackProgress: Double
    @Binding var seekTime: Int?
    
    public init(
        videoPath: URL,
        isPlaying: Binding<Bool>,
        currentProgress: Binding<Double>,
        seekTime: Binding<Int?>
    ) {
        self.player = AVPlayer(url: videoPath)
        self._playbackState = isPlaying
        self._playbackProgress = currentProgress
        self._seekTime = seekTime
    }
    
    public func makeUIView(context: Context) -> UIView {
        VideoPlayerContainer(
            player: player,
            isPlaying: $playbackState,
            progress: $playbackProgress
        )
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        guard let container = uiView as? VideoPlayerContainer else { return }
        
        if playbackState {
            if container.player.timeControlStatus != .playing {
                container.player.play()
            }
        } else {
            if container.player.timeControlStatus != .paused {
                container.player.pause()
            }
        }
        
        if let timeMs = seekTime {
            container.seekTo(timeMs: timeMs)
            self.seekTime = nil
        }
    }
}

final class VideoPlayerContainer: UIView {
    let player: AVPlayer
    private var playerDisplayLayer: AVPlayerLayer?
    private var playbackTimeObserver: Any?
    private var playerItemObserver: NSKeyValueObservation?
    
    @Binding private var playbackState: Bool
    @Binding private var playbackProgress: Double
    
    init(
        player: AVPlayer,
        isPlaying: Binding<Bool>,
        progress: Binding<Double>
    ) {
        self.player = player
        self._playbackState = isPlaying
        self._playbackProgress = progress
        super.init(frame: .zero)
        setupPlayerLayer()
        configurePlaybackObserver()
        configurePlayerItemObserver()
    }
    
    private func setupPlayerLayer() {
        playerDisplayLayer = AVPlayerLayer(player: player)
        guard let playerLayer = playerDisplayLayer else { return }
        playerLayer.frame = bounds
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerDisplayLayer?.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("Initialization with coder is not supported")
    }
    
    private func configurePlaybackObserver() {
        _ = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.1, preferredTimescale: 600),
            queue: .main
        ) { [weak self] currentTime in
            guard let self = self else { return }
            
            let totalDuration = self.player.currentItem?.duration.seconds ?? 1
            if totalDuration > 0 {
                self.playbackProgress = currentTime.seconds / totalDuration
            }
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
    }
    
    private func configurePlayerItemObserver() {
        playerItemObserver = player.currentItem?.observe(\.status, options: [.new, .initial]) { [weak self] item, _ in
            guard let self = self else { return }
            if item.status == .readyToPlay {
                DispatchQueue.main.async {
                    self.player.play()
                    self.playbackState = true
                }
            }
        }
    }
    
    @objc private func videoDidEnd() {
        player.seek(to: .zero)
        player.pause()
        playbackProgress = 0
        playbackState = false
    }
    
    func seekTo(timeMs: Int) {
        let timeInSeconds = Double(timeMs) / 1000.0
        let time = CMTime(seconds: timeInSeconds, preferredTimescale: 600)
        player.seek(to: time)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        playerItemObserver = nil
        playbackTimeObserver = nil
    }
}

//
//  RecordedPlayViewModel.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Combine
import AVFoundation

public protocol RecordedPlayerable: AnyObject {
    func pause()
    func play()
    func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime) async -> Bool
    func addPeriodicTimeObserver(forInterval interval: CMTime, queue: dispatch_queue_t?, using block: @escaping @Sendable (CMTime) -> Void) -> Any
    var currentItem: AVPlayerItem? { get }
}

public final class RecordedPlayViewModel: NSObject, ObservableObject {
    
    private let sessionQueue = DispatchQueue(label: "RecordedPlay.Session.Queue")
    private weak var player: RecordedPlayerable?
    var videoURL: CurrentValueSubject<URL, Never>
    
    // MARK: - Observer Properties
    private var addPeriodicTimeObserver: Any?
    
    // MARK: - AsynStream Properties
    private var playTimeStream: AsyncStream<(CMTime, CMTime)>.Continuation?
    private var playEndStream: AsyncStream<Void>.Continuation?
    
    public private(set) lazy var playTimeAsyncStream: AsyncStream<(CMTime, CMTime)> = AsyncStream { [weak self] in
        self?.playTimeStream = $0
    }
    
    public private(set) lazy var playEndAsyncStream: AsyncStream<(Void)> = AsyncStream { [weak self] in
        self?.playEndStream = $0
    }
    
    public init(videoURL: URL) {
        self.videoURL = CurrentValueSubject(videoURL)
        super.init()
    }
    
    deinit {
        addPeriodicTimeObserver = nil
        playTimeStream = nil
        playEndStream = nil
    }
    
    public func configurePlayer(with player: RecordedPlayerable) {
        self.player = player
        configureNotification()
    }
    
    private func configureNotification() {
        addPeriodicTimeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.03, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main) { [weak self, weak player] time in
            self?.playTimeStream?.yield((time, player?.currentItem?.duration ?? .zero))
        }
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            self?.playEndStream?.yield(())
        }
    }
    
    public func play() {
        sessionQueue.async { [weak player] in
            player?.play()
        }
    }
    
    public func pause() {
        sessionQueue.async { [weak player] in
            player?.pause()
        }
    }
    
    public func updateVideoUrl(videoURL: URL) {
        self.videoURL.send(videoURL)
    }
    
    public func seek(_ time: CMTime) async -> Bool {
        return await player?.seek(to: time,  toleranceBefore: .zero, toleranceAfter: .zero) ?? false
    }
}

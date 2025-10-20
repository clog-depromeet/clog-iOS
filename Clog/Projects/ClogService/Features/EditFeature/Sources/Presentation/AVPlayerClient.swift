//
//  AVPlayerClient.swift
//  EditFeature
//
//  Created by seunghwan Lee on 3/16/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import AVKit
import ComposableArchitecture
import Combine
import Foundation

enum Current {
    static var player: AVPlayer?
    static var asset: AVAsset?
    static var timeSubject = PassthroughSubject<Double, Never>()
    static var timeObserver: Any?
    
    static func clear() {
        Self.player = nil
        Self.asset = nil
        Self.timeObserver = nil
    }
}

extension DependencyValues {
    public var avPlayerClient: AVPlayerClient {
        get { self[AVPlayerClient.self] }
        set { self[AVPlayerClient.self] = newValue }
    }
}

public struct AVPlayerClient {
    public var initialize: @Sendable (URL) -> Effect<VideoEditFeature.Action.PlayerAction>
    public var play: @Sendable () async -> Void
    public var pause: @Sendable () async -> Void
    public var seek: @Sendable (Double) async -> Void
    public var addPeriodicTimeObserver: @Sendable () -> Effect<VideoEditFeature.Action.PlayerAction>
}

extension AVPlayerClient: DependencyKey {
    public static let liveValue = AVPlayerClient(
        initialize: { url in
            Effect.run { send in
                let asset = AVAsset(url: url)
                let playerItem = AVPlayerItem(asset: asset)
                let player = AVPlayer(playerItem: playerItem)
                
                Current.player = player
                Current.asset = asset
                
                if Current.timeObserver == nil {
                    let interval = CMTime(seconds: 0.03, preferredTimescale: 600)
                    Current.timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
                        let seconds = CMTimeGetSeconds(time)
                        Current.timeSubject.send(seconds)
                    }
                }
                
                let statusObserver = playerItem.observe(\.status, options: [.new, .old]) { item, _ in
                    switch item.status {
                    case .readyToPlay:
                        Task { @MainActor in
                            player.play()
                            try? await Task.sleep(nanoseconds: 100_000_000)
                            player.pause()
                            await player.seek(to: .zero)
                            
                            send(.playerReady)
                        }
                    default:
                        break
                    }
                }
                return {
                    statusObserver.invalidate()
                }()
            }
            .merge(with: loadAssetDuration(url: url))
        },
        play: {
            await MainActor.run {
                Current.player?.play()
            }
        },
        pause: {
            await MainActor.run {
                Current.player?.pause()
            }
        },
        seek: { time in
            await MainActor.run {
                let cmTime = CMTime(seconds: time, preferredTimescale: 600)
                Current.player?.seek(to: cmTime, toleranceBefore: .zero, toleranceAfter: .zero)
            }
        },
        
        addPeriodicTimeObserver: {
            Effect.run { send in
                guard let player = Current.player else { return }
                
                let interval = CMTime(seconds: 0.03, preferredTimescale: 600)
                let timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
                    let seconds = CMTimeGetSeconds(time)
                    Task { @MainActor in
                        send(.timeUpdated(currentTime: seconds))
                    }
                }

                return {
                    player.removeTimeObserver(timeObserver)
                }()
            }
        }
    )
    
    private static func loadAssetDuration(url: URL) -> Effect<VideoEditFeature.Action.PlayerAction> {
        Effect.run { send in
            let asset = AVAsset(url: url)
            let duration = try await asset.load(.duration)
            let durationSeconds = CMTimeGetSeconds(duration)
            
            await send(.assetLoaded(duration: durationSeconds))
            await send(.playerReady)
        }
    }
}

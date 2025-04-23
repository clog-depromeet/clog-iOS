//
//  VideoEditFeature.swift
//  EditFeature
//
//  Created by seunghwan Lee on 3/16/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit
import ComposableArchitecture
import EditDomain
import AVFoundation

@Reducer
public struct VideoEditFeature {
    public init() {}

    enum Constants {
        static let totalTrimmingWidth = UIScreen.main.bounds.width - 74
        static let playHeadWidth: CGFloat = 5
    }
    
    @ObservableState
    public struct State {
        @Presents var alert: AlertState<Action.Dialog>?
        
        var currentTime: Double = 0
        var isPlaying = false
        var playheadPosition: CGFloat = 0
        var duration: Double = 0
        var stampList: [Stamp] = []
        var popedStampList: [Stamp] = []
        var trimStartPosition: CGFloat = 0
        var trimEndPosition: CGFloat = Constants.totalTrimmingWidth
        var isVideoReady = false
        var shouldDismiss = false
        let video: Video
        
        var formattedCurrentTime: String {
            let minutes = Int(currentTime) / 60
            let seconds = Int(currentTime) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
        
        public init(video: Video) {
            self.video = video
        }
    }
    
    public enum Action {
        public enum Delegate {
            case edittedVideo(video: Video)
        }
        
        case alert(PresentationAction<Dialog>)
        case didTapStamp
        case didTapPlayPause
        case didTapUndoStamp
        case didTapRedoStamp
        case updatePlayHead(newPosition: CGFloat)
        case updateTrimStartPosition(position: CGFloat)
        case updateTrimEndPosition(position: CGFloat)
        case playerResponse(PlayerAction)
        case didTapEditCancel
        case didTapEditCompelete
        case delegate(Delegate)
        case onAppear
        case dismiss
        
        public enum PlayerAction: Equatable {
            case assetLoaded(duration: Double)
            case playbackStatusChanged(isPlaying: Bool)
            case timeUpdated(currentTime: Double)
            case playerReady
            case seekCompleted
        }
        
        @CasePathable
        public enum Dialog: Equatable {
            case confirm
            case cancel
        }
    }
    
    @Dependency(\.avPlayerClient) var avPlayerClient
    @Dependency(\.dismiss) var dismiss
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.trimEndPosition = Constants.totalTrimmingWidth
                
                return .merge(
                    avPlayerClient.initialize(state.video.videoUrl)
                        .map { .playerResponse($0) },
                    
                    avPlayerClient.addPeriodicTimeObserver()
                        .map { .playerResponse($0) }
                )
            case .didTapStamp:
                state.stampList.append(Stamp(time: state.currentTime, xPos: state.playheadPosition, isValid: isStampValid(position: state.playheadPosition, state: state)))
                state.popedStampList.removeAll()
                return .none
            case .didTapPlayPause:
                state.isPlaying.toggle()
                
                if state.isPlaying {
                    // 플레이헤드가 트리밍 범위 밖이면 시작 지점으로 이동
                    if state.playheadPosition < state.trimStartPosition || state.playheadPosition > state.trimEndPosition {
                        let screenWidth = Constants.totalTrimmingWidth
                        let trimStartTime = (state.trimStartPosition / screenWidth) * state.duration
                        
                        state.playheadPosition = state.trimStartPosition
                        
                        return .run { send in
                            await avPlayerClient.seek(trimStartTime)
                            await avPlayerClient.play()
                            await send(.playerResponse(.playbackStatusChanged(isPlaying: true)))
                        }
                    } else {
                        return .run { _ in
                            await avPlayerClient.play()
                        }
                    }
                } else {
                    return .run { _ in
                        await avPlayerClient.pause()
                    }
                }
            case .didTapUndoStamp:
                guard let poppedStamp = state.stampList.popLast() else { return .none }
                state.popedStampList.append(poppedStamp)
                return .none
            case .didTapRedoStamp:
                guard let poppedStamp = state.popedStampList.popLast() else { return .none }
                state.stampList.append(poppedStamp)
                return .none
            case let .updatePlayHead(newPosition):
                // 플레이헤드 위치가 트리밍 범위 내에 있도록 제한
                let constrainedPosition = min(max(newPosition, state.trimStartPosition), state.trimEndPosition - Constants.playHeadWidth)
                state.playheadPosition = constrainedPosition
                
                // 플레이헤드 위치에 해당하는 시간으로 비디오 탐색
                let screenWidth = Constants.totalTrimmingWidth
                let time = (constrainedPosition / screenWidth) * state.duration
                
                return .run { _ in
                    await avPlayerClient.seek(time)
                }
            case let .updateTrimStartPosition(position):
                state.trimStartPosition = position
                updateStampValidity(state: &state)
                
                if position > state.playheadPosition {
                    state.playheadPosition = position
                    return .run { send in
                        await avPlayerClient.pause()
                        await send(.playerResponse(.playbackStatusChanged(isPlaying: false)))
                        await MainActor.run {
                            send(.updatePlayHead(newPosition: position))
                        }
                    }
                } else {
                    return .none
                }
            case let .updateTrimEndPosition(position):
                state.trimEndPosition = position
                state.playheadPosition = min(state.playheadPosition, position - Constants.playHeadWidth)
                updateStampValidity(state: &state)
                return .none
            case let .playerResponse(playerAction):
                switch playerAction {
                case let .assetLoaded(duration):
                    state.duration = duration
                    state.stampList = state.video.stampTimeList.map { Stamp(time: $0, stampAreaWidth: Constants.totalTrimmingWidth, videoDuration: duration) }
                    return .none
                case let .playbackStatusChanged(isPlaying):
                    state.isPlaying = isPlaying
                    return .none
                case let .timeUpdated(currentTime):
                    state.currentTime = currentTime
                    
                    // 플레이헤드 위치 계산 및 업데이트
                    let screenWidth = Constants.totalTrimmingWidth
                    let newPosition = (currentTime / state.duration) * screenWidth + 0.1
                    
                    // 트리밍 영역을 벗어난 경우 처리
                    if newPosition < state.trimStartPosition && state.isPlaying || newPosition > state.trimEndPosition - Constants.playHeadWidth && state.isPlaying {
                        let trimStartTime = (state.trimStartPosition / screenWidth) * state.duration
                        let trimStartPos = state.trimStartPosition
                        state.isPlaying = false
                         
                        return .run { send in
                            await avPlayerClient.pause()
                            await send(.playerResponse(.playbackStatusChanged(isPlaying: false)))
                            await MainActor.run {
                                send(.updatePlayHead(newPosition: trimStartPos))
                            }
                        }
                    } else {
                        // 정상 범위 내에서는 플레이헤드 업데이트
                        state.playheadPosition = min(newPosition, state.trimEndPosition - Constants.playHeadWidth)
                    }
                    return .none
                case .playerReady:
                    state.isVideoReady = true
                    return .none
                case .seekCompleted:
                    return .none
                }
            case .didTapEditCancel:
                
                state.alert = AlertState {
                    TextState("편집 취소")
                } actions: {
                    ButtonState(action: .confirm) {
                        TextState("저장 안함")
                    }
                    ButtonState(action: .cancel) {
                        TextState("계속 편집")
                    }
                } message: {
                    TextState("이 페이지를 나가면\n편집 내용이 적용되지 않아요")
                }
                if state.isPlaying {
                    return .send(.didTapPlayPause)
                } else {
                    return .none
                }
            case .alert(.presented(.confirm)):
                let videoUrl = state.video.videoUrl
                return .run { send in
                    await avPlayerClient.pause()
                    await send(.delegate(.edittedVideo(video: Video(videoUrl: videoUrl, stampTimeList: []))))
                    await send(.playerResponse(.playbackStatusChanged(isPlaying: false)))
                    await send(.dismiss)
                }
            case .alert(.presented(.cancel)):
                return .none
            case .didTapEditCompelete:
                let videoURL = state.video.videoUrl
                let stamps = state.stampList
                let trimStartTime = (state.trimStartPosition / Constants.totalTrimmingWidth) * state.duration
                let trimEndTime = (state.trimEndPosition / Constants.totalTrimmingWidth) * state.duration

                return .run { send in
                    let video = try await trimVideo(sourceURL: videoURL, startTime: trimStartTime, endTime: trimEndTime, stamps: stamps)
                    await avPlayerClient.pause()
                    await send(.delegate(.edittedVideo(video: video)))
                    await send(.playerResponse(.playbackStatusChanged(isPlaying: false)))
                    await send(.dismiss)
                }
            case .dismiss:
                Current.clear()
                state.shouldDismiss = true
                return .none
            default:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
    
    private func updateStampValidity(state: inout State) {
        state.stampList = state.stampList.map { stamp in
            Stamp(time: stamp.time, xPos: stamp.xPos, isValid: isStampValid(position: stamp.xPos, state: state))
        }
    }
    
    private func isStampValid(position: CGFloat, state: State) -> Bool {
        return position >= state.trimStartPosition && position <= state.trimEndPosition - Constants.playHeadWidth
    }

    func trimVideo(sourceURL: URL, startTime: Double, endTime: Double, stamps: [Stamp]) async throws -> Video {
        // 비디오 에셋 생성
        let asset = AVAsset(url: sourceURL)
        let composition = AVMutableComposition()
        
        // 비디오와 오디오 트랙 가져오기
        guard let videoTrack = try await asset.loadTracks(withMediaType: .video).first, let compositionVideoTrack = composition.addMutableTrack(
                withMediaType: .video,
                preferredTrackID: kCMPersistentTrackID_Invalid) else {
            throw NSError(domain: "TrimVideo", code: 400, userInfo: [NSLocalizedDescriptionKey: "비디오 트랙을 찾을 수 없습니다"])
        }
        
        // 원본 영상 회전 정보 저장
        let transform = try? await videoTrack.load(.preferredTransform)
        
        // 비디오 타임라인에 삽입
        let timeRange = CMTimeRange(
            start: CMTime(seconds: startTime, preferredTimescale: 600),
            end: CMTime(seconds: endTime, preferredTimescale: 600)
        )
        
        try compositionVideoTrack.insertTimeRange(
            timeRange,
            of: videoTrack,
            at: .zero
        )
        
        // 영상 회전 정보 추가
        if let transform {
            compositionVideoTrack.preferredTransform = transform
        }
        
        // 오디오 트랙이 있으면 추가
        if let audioTrack = try await asset.loadTracks(withMediaType: .audio).first,
           let compositionAudioTrack = composition.addMutableTrack(
            withMediaType: .audio,
            preferredTrackID: kCMPersistentTrackID_Invalid) {
            
            try compositionAudioTrack.insertTimeRange(
                timeRange,
                of: audioTrack,
                at: .zero
            )
        }
        
        // 임시 파일 URL 생성
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("mp4")
        
        // 파일이 이미 존재하면 삭제
        if FileManager.default.fileExists(atPath: outputURL.path) {
            try FileManager.default.removeItem(at: outputURL)
        }
        
        // 내보내기 세션 설정
        guard let exportSession = AVAssetExportSession(
            asset: composition,
            presetName: AVAssetExportPresetHighestQuality
        ) else {
            throw NSError(domain: "TrimVideo", code: 400, userInfo: [NSLocalizedDescriptionKey: "내보내기 세션을 생성할 수 없습니다"])
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.shouldOptimizeForNetworkUse = true

        // export(to:as:) 메서드 사용
        await exportSession.export()

        // 내보내기 완료 후 결과 반환
        let stampTimeList = stamps.filter { $0.isValid }.compactMap { $0.time - startTime }
        
        return Video(videoUrl: outputURL, videoDuration: endTime - startTime, stampTimeList: stampTimeList)
    }
}

//
//  RecordingFeature.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Combine
import VideoDomain
import VideoFeatureInterface

import ComposableArchitecture

@Reducer
public struct RecordingFeature {
    @Dependency(\.videoDataManager) private var videoDataManager
    @Dependency(\.continuousClock) var clock
    
    @ObservableState
    public struct State: Equatable {
        var elapsedTime: TimeInterval = 0
        var fileName: String = ""
        let viewModel: RecordingPlayViewModel = .init()
        
        // 저장된 난이도 정보 확인
        var grade: SavedGrade?
        
        // 저장된 스토리가 있는지 확인
        var count: Int = 0
    }
    
    public enum Action: Equatable {
        case onAppear
        
        // 카메라 on/off Action
        case onStartSession
        case onStopSession
        
        // 녹화 시작 Action
        case onStartRecording
        case onStopRecording
        
        // 녹화 linstening 이벤트
        case startListening
        
        // 타이머 on/off
        case onStartDuration
        case timerTicked
        case onSTopDuration
        
        // 촬영 완료
        case finishRecording(path: URL)
        
        // 화면 전환
        case presentRecorded(fileName: String, path: URL)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce(reduceCore)
    }
}

extension RecordingFeature {
    
    private func reduceCore(
        _ state: inout State,
        action: Action
    ) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.count = videoDataManager.getCount()
            state.grade = videoDataManager.getSavedGrade()
            return .run { send in
                await send(.onStartSession)
                await send(.onStartRecording)
            }
            
        case .onStartSession:
            state.viewModel.startSession()
            return .none
            
        case .onStopSession:
            return .run { [weak viewModel = state.viewModel]send in
                await viewModel?.stopSession()
            }
            
        case .onStartRecording:
            
            // 파일 형식이 필요함
            state.fileName = UUID().uuidString + ".mov"
            let fileURL = URL(fileURLWithPath: NSTemporaryDirectory() + state.fileName)
            state.viewModel.startRecording(to: fileURL)
            
            return .merge(
                .send(.startListening),
                .send(.onStartDuration)
            )
            
        case .onStopRecording:
            state.viewModel.stopRecording()
            return .run { send in
                await send(.onSTopDuration)
            }
            
        case .startListening:
            return .run { [weak viewModel = state.viewModel] send in
                guard let viewModel else { return }
                for await result in viewModel.recordingOutputAsyncStream {
                    // 촬영 결과를 가져옴
                    await viewModel.stopSession()
                    
                    await send(.finishRecording(path: result.1))
                }
            }.cancellable(id: "startListening", cancelInFlight: true)
            
        case .onStartDuration:
            return .run { send in
                for await _ in clock.timer(interval: .seconds(0.01)) {
                    await send(.timerTicked)
                }
            }
            .cancellable(id: "Timer", cancelInFlight: true)
            
        case .timerTicked:
            state.elapsedTime += 1.0
            return .none
            
        case .onSTopDuration:
            return .cancel(id: "Timer")
            
        case .finishRecording(let path):
            let fileName = state.fileName
            let totalDuration = state.elapsedTime
            return .run { send in
                // 성공/실패 화면으로 전환
                await send(.presentRecorded(
                    fileName: fileName,
                    path: path
                ))
            }
            
        case .presentRecorded:
            return .cancel(id: "startListening")
        }
    }
}

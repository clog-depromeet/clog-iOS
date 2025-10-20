//
//  RecordFeatrue.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct RecordHomeFeature {
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        
        var recordingState: RecordingFeature.State?
        var recordedState: RecordedFeature.State?
    }
    
    public enum Action {
        
        case onAppear
        
        // Recording Action: - 녹화 액션
        case recordingAction(RecordingFeature.Action)
        // Recorded Action: - 녹화 완료 / 성공, 실패, 편집, close 할 수 있는 화면
        case recordedAction(RecordedFeature.Action)
        
        case moveEditRecord(URL, [Double])
        case recordEnd
        case saveSuccess
        case changeLoadingState(Bool)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce(reduceCore)
            .ifLet(\.recordingState, action: \.recordingAction) {
                RecordingFeature()
            }
            .ifLet(\.recordedState, action: \.recordedAction) {
                RecordedFeature()
            }
    }
}

extension RecordHomeFeature {
    
    /// Reducer
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: 액션
    /// - Returns: Effect
    private func reduceCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.recordingState = .init()
            return .none
            
        case .recordingAction(let action):
            return recordingReduceCore(&state, action)
            
        case .recordedAction(let action):
            return recordedReduceCore(&state, action)
        
        case .moveEditRecord(let path, let timeStampList):
            return .none
            
        default:
            return .none
        }
    }
}

private extension RecordHomeFeature {
    
    /// Recording Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: RecordingAction
    /// - Returns: Effect
    func recordingReduceCore(
        _ state: inout State,
        _ action: RecordingFeature.Action
    ) -> Effect<Action> {
        switch action {
        case .presentRecorded(let fileName, let path):
            state.recordedState = .init(
                fileName: fileName,
                path: path
            )
            state.recordingState = nil
            return .none
        default:
            return .none
        }
    }
}

private extension RecordHomeFeature {
    
    /// Recording Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: RecordingAction
    /// - Returns: Effect
    func recordedReduceCore(
        _ state: inout State,
        _ action: RecordedFeature.Action
    ) -> Effect<Action> {
        switch action {
        case .moveEditRecord(let path, let timeStampList):
            return .run { send in
                await send(.moveEditRecord(path, timeStampList))
            }
            
        case .saveSuccess:
            return .send(.saveSuccess)
            
        case .close:
            state.recordingState = nil
            state.recordedState = nil
            return .run { send in
                await send(.recordEnd)
            }
            
        case .changeLoadingState(let isLoading):
            return .send(.changeLoadingState(isLoading))
            
        default:
            return .none
        }
    }
}

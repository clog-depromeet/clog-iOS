//
//  MainFeature.swift
//  ClogService
//
//  Created by lin.saeng on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

// Apple Module
import SwiftUI

// 내부 Module
import Shared
import VideoFeature
import FolderTabFeature
import FolderFeature
import CalendarFeature
import ReportFeature

// 외부 Module
import ComposableArchitecture
import DesignKit

@Reducer
public struct MainFeature {
    
    @ObservableState
    public struct State: Equatable {

        // Main Tab State
        var selectedTab: Int = 0
        
        // Video Tab State
        var vidoeTabState: VideoFeature.State = .init()
        
        // Record State
        var recordState: RecordHomeFeature.State?
        
        // FolderTab State
        var folderTabState: FolderTabFeature.State = .init()
        
        // Folder State
        var folderState: FolderFeature.State = .init()
        
        // CalendarMain State
        var calendarMainState: CalendarMainFeature.State = .init()
        
        // CalendarDetail State
        var calendarDetailState: CalendarDetailFeature.State?
        
        // Report State
        var reportState: ReportFeature.State = .init()
        
        var isRecording: Bool = false
        
        var pushToCalendarDetail: Int?
        
        var toast: Toast?
        
        var tabImages: [Image] = [
            Image.clogUI.folder,
            Image.clogUI.camera,
            Image.clogUI.report
        ]
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        // Main Tab Action
        case selectedTab(Int)
        case pushToCalendarDetailCompleted
        
        // Video Tab Action
        case videoTabAction(VideoFeature.Action)
        
        // RecordTabbar Action
        case recordFeatureAction(RecordHomeFeature.Action)
        
        // FolderTabFeature
        case folderTabAction(FolderTabFeature.Action)
        case folderAction(FolderFeature.Action)
        case calendarMainAction(CalendarMainFeature.Action)
        case calendarDetailAction(CalendarDetailFeature.Action)
        case reportAction(ReportFeature.Action)
        
        case routerAction(RouterAction)
        
        public enum RouterAction {
            case pushToCalendarDetail(Int)
            case pushToSetting
            case pushToAttempt(Int)
            case presentToEdit(URL, [Double])
            case pushToCompletionReport(Int?)
        }
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.vidoeTabState, action: \.videoTabAction) {
            ClogDI.container.resolve(VideoFeature.self)!
        }
        
        Scope(state: \.folderTabState, action: \.folderTabAction) {
            FolderTabFeature()
        }
        
        Scope(state: \.folderState, action: \.folderAction) {
            FolderFeature()
        }
        
        Scope(state: \.calendarMainState, action: \.calendarMainAction) {
            CalendarMainFeature()
        }
        
        Scope(state: \.reportState, action: \.reportAction) {
            ReportFeature()
        }
        
        Reduce(reducerCore)
            .ifLet(\.recordState, action: \.recordFeatureAction) {
                ClogDI.container.resolve(RecordHomeFeature.self)!
            }
            .ifLet(\.calendarDetailState, action: \.calendarDetailAction) {
                CalendarDetailFeature()
            }
    }
}

private extension MainFeature {
    
    /// Main Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: Main Action
    /// - Returns: Effect
    func reducerCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .selectedTab(let index):
            // 탭 선택 시 전달 되는 Action
            return .merge(
                // 각 탭 Feature에 전달
                // folder, report도 전달하기 위해서 merge
                .send(.videoTabAction(.selectedTab(index)))
            )
            
        case .pushToCalendarDetailCompleted:
            state.pushToCalendarDetail = nil
            return .none
            
        case .videoTabAction(let action):
            // 비디오 화면 - Action
            return videoCore(&state, action)
            
        case .recordFeatureAction(let action):
            // 녹화 화면 - Action
            return recordCore(&state, action)
        case .folderTabAction(let action):
            // 폴더 탭 - Action
            return folderTabCore(&state, action)
        case .folderAction(let action):
            // 폴더 - Action
            return folderCore(&state, action)
        case .calendarMainAction(let action):
            // 캘린더 - Action
            return calendarMainCore(&state, action)
        case .calendarDetailAction(let action):
            return calendarDetailCore(&state, action)
        case .reportAction(let action):
            // 리포트 - Action
            return reportCore(&state, action)
        default:
            return .none
        }
    }
}

private extension MainFeature {
    
    /// Record Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: Record Action
    /// - Returns: Effect
    func recordCore(
        _ state: inout State,
        _ action: RecordHomeFeature.Action
    ) -> Effect<Action> {
        switch action {
        case .recordEnd:
            state.recordState = nil
            state.isRecording = false
            return .run { send in
                await send(.videoTabAction(.onStartSession))
            }
            
        case .saveSuccess:
            state.recordState = nil
            state.isRecording = false
            state.toast = Toast(message: "영상을 저장했습니다.", type: .success)
            return .run { send in
                await send(.videoTabAction(.onStartSession))
            }
            
        case .changeLoadingState:
            // 영상 저장 중
            return .none
            
        case .moveEditRecord(let path, let stampTimeList):
            return .send(.routerAction(.presentToEdit(path, stampTimeList)))
        default:
            return .none
        }
    }
}

private extension MainFeature {
    
    /// Video Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: Video Action
    /// - Returns: Effect
    func videoCore(
        _ state: inout State,
        _ action: VideoFeature.Action
    ) -> Effect<Action> {
        switch action {
            // 탭
        case .onStartRecord:
            withAnimation(.easeInOut(duration: 0.3)) {
                state.isRecording = true
                // 영상 촬영 시작
                state.recordState = .init()
            }
            return .none
            
        case .recordCompleted(let storyId):
            return .send(.routerAction(.pushToCompletionReport(storyId)))
        default:
            return .none
        }
    }
}

private extension MainFeature {
    /// Video Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: FolderTab Action
    /// - Returns: Effect
    func folderTabCore(
        _ state: inout State,
        _ action: FolderTabFeature.Action
    ) -> Effect<Action> {
        switch action {
        default:
            return .none
        }
    }
}

private extension MainFeature {
    /// Video Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: Folder Action
    /// - Returns: Effect
    func folderCore(
        _ state: inout State,
        _ action: FolderFeature.Action
    ) -> Effect<Action> {
        switch action {
        case .moveToAttempt(let attemptId):
            return .send(.routerAction(.pushToAttempt(attemptId)))
        default:
            return .none
        }
    }
}

private extension MainFeature {
    /// Video Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: CalendarMainFeature Action
    /// - Returns: Effect
    func calendarMainCore(
        _ state: inout State,
        _ action: CalendarMainFeature.Action
    ) -> Effect<Action> {
        switch action {
        case .moveToCalendarDetail(let storyId):
            // 캘린더 상세 페이지로 이동
            return .send(.routerAction(.pushToCalendarDetail(storyId)))
        default:
            return .none
        }
    }
}

private extension MainFeature {
    /// Video Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: CalendarDetailFeature Action
    /// - Returns: Effect
    func calendarDetailCore(
        _ state: inout State,
        _ action: CalendarDetailFeature.Action
    ) -> Effect<Action> {
        switch action {
        default:
            return .none
        }
    }
}

private extension MainFeature {
    /// Report Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: CalendarDetailFeature Action
    /// - Returns: Effect
    func reportCore(
        _ state: inout State,
        _ action: ReportFeature.Action
    ) -> Effect<Action> {
        switch action {
        case .settingTapped:
            return .send(.routerAction(.pushToSetting))
        default:
            return .none
        }
    }
}

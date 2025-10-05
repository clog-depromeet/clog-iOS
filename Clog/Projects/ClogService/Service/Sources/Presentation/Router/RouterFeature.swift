//
//  CoordinatorFeature.swift
//  ClogService
//
//  Created by Junyoung Lee on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture
import CalendarFeature
import SettingFeature
import FolderFeature
import EditFeature
import CompletionReportFeature
import AddAttemptsFeatureInterface
import ReportFeature
import ReportDomain
import SocialDomain
import Core
import DesignKit

@Reducer
public struct RouterFeature {
    @MainActor
    public static var initialStore: StoreOf<RouterFeature> {
        Store(
            initialState: State(),
            reducer: { RouterFeature() }
        )
    }
    
    public init() {}
    
    @ObservableState
    public struct State {
        var rootState: RootFeature.State = RootFeature.State()
        var videoEditState: VideoEditFeature.State?
        var isPresentEdit: Bool = false
        var path = StackState<Path.State>()
        var toast: Toast?
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case rootAction(RootFeature.Action)
        case videoEditAction(VideoEditFeature.Action)
        case path(StackActionOf<Path>)
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.rootState, action: \.rootAction) {
            RootFeature()
        }
        
        Reduce(reducerCore)
            .forEach(\.path, action: \.path)
            .ifLet(\.videoEditState, action: \.videoEditAction) {
                VideoEditFeature()
            }
    }
}

extension RouterFeature {
    public func reducerCore(state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .videoEditAction(let action):
            return videoEditCore(state: &state, action: action)
        case .rootAction(let action):
            return rootCore(state: &state, action: action)
        
        // Calendar Detail
        case .path(.element(id: let id, action: .calendarDetail(.backButtonTapped))):
            // 캘린더 상세 페이지 pop
            state.path.pop(from: id)
            return .none
        case .path(.element(id: let id, action: .calendarDetail(.deleteStorySuccess))):
            state.path.pop(from: id)
            state.toast = Toast(message: "기록을 삭제했습니다.", type: .success)
            return .none
            
        // Folder Detail
        case .path(.element(id: let id, action: .attempt(.backButtonTapped))):
            state.path.pop(from: id)
            return .none
        case let .path(.element(id: id, action: .attempt(.deleteAttemptFinished))):
            state.path.pop(from: id)
            state.toast = Toast(message: "기록을 삭제했습니다.", type: .success)
            return .none
            
        // add attempts view
        case let .path(.element(id: id, action: .addAttempts(.delegate(.dismissView)))):
            state.path.pop(from: id)
            return .none
            
        case let .path(.element(id: id, action: .addAttempts(.view(.didSavedAttempts)))):
            state.path.pop(from: id)
            return .none
            
        // Setting
        case .path(.element(id: let id, action: .setting(.backButtonTapped))):
            state.path.pop(from: id)
            return .none
        case .path(.element(id: let id, action: .setting(.exitToStart))):
            state.path.pop(from: id)
            state.rootState.mainState = nil
            state.rootState.loginState = .init()
            return .none
        case let .path(.element(id: _, action: .setting(.pushWebView(url)))):
            state.path.append(.webView(WebViewFeature.State(urlString: url)))
            return .none
            
        // Setting WebView
        case let .path(.element(id: id, action: .webView(.backButtonTapped))):
            state.path.pop(from: id)
            return .none
        
        // CompletionReport 
        case let .path(.element(id: id, action: .completionReport(.finish))):
            state.path.pop(from: id)
            return .none
            
        // Report
        case let .path(.element(id: id, action: .report(.backButtonTapped))):
            state.path.pop(from: id)
            return .none
            
        default:
            return .none
        }
    }
    
    public func rootCore(state: inout State, action: RootFeature.Action) -> Effect<Action> {
        switch action {
        case let .mainAction(.routerAction(.pushToCalendarDetail(storyId))):
            // 캘린더 상세 페이지 push
            state.path.append(.calendarDetail(CalendarDetailFeature.State(storyId: storyId)))
            return .none
            
        case .mainAction(.routerAction(.pushToSetting)):
            state.path.append(.setting(SettingFeature.State()))
            return .none
            
        case let .mainAction(.routerAction(.pushToAttempt(attemptId))):
            state.path.append(.attempt(AttemptFeature.State(attemptId: attemptId)))
            return .none
            
        case .mainAction(.routerAction(.pushToAddAttempts)):
            state.path.append(.addAttempts(AddAttemptsFeature.State()))
            return .none
            
        case let .mainAction(.routerAction(.presentToEdit(url, stampTimeList))):
            state.isPresentEdit = true
            state.videoEditState = VideoEditFeature.State(video: .init(videoUrl: url, stampTimeList: stampTimeList))
            return .none
            
        case let .mainAction(.routerAction(.pushToCompletionReport(storyId))):
            guard let storyId else { return .none }
            state.path.append(.completionReport(CompletionReportFeature.State(storyId: storyId)))
            return .none
            
        case let .mainAction(.socialTabAction(.delegate(.navigateToReport(friend)))):
            state.path.append(
                .report(
                    ReportFeature.State(
                        reportUser: .init(userId: friend.id,userName: friend.nickName)
                    )
                )
            )
            return .none
            
        default:
            return .none
        }
    }
    
    public func videoEditCore(state: inout State, action: VideoEditFeature.Action) -> Effect<Action> {
        switch action {
        case .delegate(.edittedVideo(let video)):
            return .send(
                .rootAction(
                    .mainAction(
                        .recordFeatureAction(
                            .recordedAction(.updateVideo(video))
                        )
                    )
                )
            )
        default:
            return .none
        }
    }
}

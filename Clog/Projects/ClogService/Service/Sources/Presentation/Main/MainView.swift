//
//  MainView.swift
//  ClogService
//
//  Created by lin.saeng on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

/// Apple Module
import UIKit
import SwiftUI

/// 내부 Module
import VideoFeature
import FolderTabFeature

/// 외부 Module
import ComposableArchitecture
import FolderFeature
import CalendarFeature
import ReportFeature
import DesignKit

/// 구현부
public struct MainView: View {
    
    // MARK: - Private Properties
    @Bindable private var store: StoreOf<MainFeature>
    
    @State private var selectedTab: Int = 1
    
    /// 초기화
    /// - Parameters:
    ///   - store: MainFeature
    public init(
        store: StoreOf<MainFeature>
    ) {
        self.store = store
    }
    
    public var body: some View {
        bodyView
            .toast($store.toast)
    }
}

private extension MainView {
    var bodyView: some View {
        ZStack {
            
            // 탭 뷰
            tabView
            
            // 영상 녹화 화면
            IfLetStore(store.scope(state: \.recordState, action: \.recordFeatureAction)) { store in
                RecordHomeView(store: store)
            }
        }
    }
}

// MARK: - TabView
private extension MainView {
    var tabView: some View {
        // 메인 화면 전체
        TabView(selection: $selectedTab) {
            ForEach(Array([AnyView(folderTabbarView), AnyView(videoTabbarView), AnyView(reportTabbarView)].enumerated()), id: \.offset) { index, view in
                view
                    .tabItem {
                        store.tabImages[index]
                    }
                    .toolbarBackground(Color.clogUI.gray700, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                    .onAppear {
                        store.send(.selectedTab(index))
                    }
            }
        }
        .tint(Color.clogUI.white)
    }
}

// MARK: - Folder Tabbar View
private extension MainView {
    var folderTabbarView: some View  {
        FolderTabView<FolderView, CalendarMainView>(
            store: store.scope(
                state: \.folderTabState,
                action: \.folderTabAction
            ),
            folderView: FolderView(
                store: store.scope(
                    state: \.folderState,
                    action: \.folderAction
                )
            ),
            calendarView: CalendarMainView(
                store: store.scope(
                    state: \.calendarMainState,
                    action: \.calendarMainAction
                )
            )
        )
    }
}

// MARK: - Video Tabbar View
private extension MainView {
    
    var videoTabbarView: some View {
        VideoView(
            store: store.scope(state: \.vidoeTabState, action: \.videoTabAction)
        )
    }
}

// MARK: - Report Tabbar View
private extension MainView {
    
    var reportTabbarView: some View {
        ReportView(
            store: store.scope(state: \.reportState, action: \.reportAction)
        )
    }
}

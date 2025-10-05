//
//  CoordinatorView.swift
//  ClogService
//
//  Created by Junyoung Lee on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import CalendarFeature
import SettingFeature
import FolderFeature
import EditFeature
import CompletionReportFeature
import AddAttemptsFeature
import ReportFeature
import Core
import DesignKit

public struct RouterView: View {
    @Bindable private var store: StoreOf<RouterFeature>
    
    public init(store: StoreOf<RouterFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: \.path)) {
            RootView(
                store: store.scope(
                    state: \.rootState,
                    action: \.rootAction
                )
            )
            .navigationBarBackButtonHidden(true)
        } destination: { store in
            switch store.case {
            case .calendarDetail(let store):
                CalendarDetailView(store: store)
                    .navigationBarBackButtonHidden(true)
            case .setting(let store):
                SettingView(store: store)
                    .navigationBarBackButtonHidden(true)
            case .attempt(let store):
                AttemptView(store: store)
                    .navigationBarBackButtonHidden(true)
            case .addAttempts(let store):
                AddAttemptsView(store: store)
                    .navigationBarBackButtonHidden(true)
            case .webView(let store):
                WebView(store: store)
                    .navigationBarBackButtonHidden(true)
            case .completionReport(let store):
                CompletionReportView(store: store)
                    .navigationBarBackButtonHidden(true)
            case .report(let store):
                ReportView(store: store)
                    .navigationBarBackButtonHidden(true)
            }
        }
        .fullScreenCover(isPresented: $store.isPresentEdit) {
            IfLetStore(
                store.scope(state: \.videoEditState, action: \.videoEditAction), then: VideoEditView.init
            )
        }
        .toast($store.toast)
    }
}

#Preview {
    RouterView(
        store: .init(
            initialState: RouterFeature.State(),
            reducer: {
                RouterFeature()
            }
        )
    )
}

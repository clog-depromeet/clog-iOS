//
//  FolderTabView.swift
//  FolderTabFeatureFeature
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import Core
import DesignKit

public struct FolderTabView<FolderView: ViewProtocol, CalendarView: ViewProtocol>: View {
    @Bindable var store: StoreOf<FolderTabFeature>
    
    private let folderView: FolderView
    private let calendarView: CalendarView
    
    public init(
        store: StoreOf<FolderTabFeature>,
        folderView: FolderView,
        calendarView: CalendarView
    ) {
        self.store = store
        self.folderView = folderView
        self.calendarView = calendarView
    }
    
    public var body: some View {
        makeBody()
            .debugFrameSize()
    }
}

extension FolderTabView {
    private func makeBody() -> some View {
        VStack(spacing: 0) {
            
            makeTabBar()
                .padding(.top, 15)
                .background(Color.clogUI.gray900)
            
            makeContent()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func makeTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(FolderTabFeature.TabType.allCases, id: \.self) { tab in
                VStack(spacing: 0) {
                    Button {
                        store.send(.tabBarTapped(tab))
                    } label: {
                        Text(tab.rawValue)
                            .font(
                                store.selectedTab == tab ?
                                .h4 : .b1
                            )
                            .foregroundStyle(
                                store.selectedTab == tab ?
                                Color.clogUI.primary : Color.clogUI.gray400
                            )
                            .frame(height: 42)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                    }
                    
                    ZStack {
                        Rectangle()
                            .fill(
                                store.selectedTab == tab ?
                                Color.clogUI.primary : Color.clear
                            )
                            .frame(height: 2)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func makeContent() -> some View {
        switch store.selectedTab {
        case .folder:
            folderView.makeView()
        case .calendar:
            calendarView.makeView()
        }
    }
}

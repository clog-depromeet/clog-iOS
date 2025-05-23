//
//  SocialTabView.swift
//  SocialFeature
//
//  Created by 강현준 on 5/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit

@Reducer
public struct SocialTabFeature {
    
    @ObservableState
    public struct State: Equatable {
        var selectedTab: CurrentTab = .follower
    }
    
    public enum Action: BindableAction {
        
        case binding(BindingAction<State>)
        
        case selectTab(SocialTabFeature.State.CurrentTab)
    }
    
    public var body: some Reducer<State, Action> {
        
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .selectTab(let tab):
                state.selectedTab = tab
                return .none
                
            default:
                return .none
            }
        }
    }
}

public extension SocialTabFeature.State {
    enum CurrentTab: String, Hashable {
        case follower = "팔로워"
        case following = "팔로잉"
    }
}

public struct SocialTabView: View {
    
    @Bindable private var store: StoreOf<SocialTabFeature>
    
    public init(
        store: StoreOf<SocialTabFeature>
    ) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                
                VStack(spacing: 0) {
                    Button {
                        store.send(.selectTab(.follower))
                    } label: {
                        HStack {
                            Spacer()
                            Text("팔로워")
                                .font(.b1)
                                .foregroundStyle(
                                    store.selectedTab == .follower
                                    ? Color.clogUI.primary
                                    : Color.clogUI.gray400
                                )
                            Spacer()
                        }
                    }
                    
                    DividerView(
                        .horizontal,
                        color: store.selectedTab == .follower
                        ? .clogUI.primary
                        : .clear
                    )
                }
                
                VStack(spacing: 0) {
                    Button {
                        store.send(.selectTab(.following))
                    } label: {
                        HStack {
                            Spacer()
                            Text("팔로잉")
                                .font(.b1)
                                .foregroundStyle(
                                    store.selectedTab == .following
                                    ? Color.clogUI.primary
                                    : Color.clogUI.gray400
                                )
                            Spacer()
                        }
                    }
                    
                    DividerView(
                        .horizontal,
                        color: store.selectedTab == .following
                        ? .clogUI.primary
                        : .clear
                    )
                }
            }
            TabView(selection: $store.selectedTab) {
               
            }
        }
    }
}

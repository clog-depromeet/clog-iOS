//
//  SocialTabFeature.swift
//  SocialFeature
//
//  Created by 강현준 on 5/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture
import Core
import SocialDomain

@Reducer
public struct SocialTabFeature {
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public var selectedTab: CurrentTab = .follower
        public var socialFriends: [SocialFriend] = []
        public var recommendFriends: [SocialFriend] = SocialFriend.dummy()
        public init() { }
    }
    
    public enum Action: BindableAction, FeatureAction, ViewAction {
        case binding(BindingAction<State>)
        case inner(InnerAction)
        case async(AsyncAction)
        case scope(ScopeAction)
        case delegate(DelegateAction)
        case view(View)
    }
    
    public enum View {
        case selectTab(SocialTabFeature.State.CurrentTab)
        case followButtonTapped(SocialFriend)
        case moreButtonTapped(SocialFriend)
    }
    
    public enum InnerAction { }
    public enum AsyncAction { }
    public enum ScopeAction { }
    public enum DelegateAction { }
    
    public var body: some Reducer<State, Action> {
        
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .view(let action):
                return viewCore(&state, action)
                
            default:
                return .none
            }
        }
    }
    
    func viewCore(_ state: inout State, _ action: View) -> Effect<Action> {
        switch action {
        case .selectTab(let tab):
            state.selectedTab = tab
            return .none
        case .followButtonTapped(let f):
            // TODO: 팔로우 / 팔로잉
            return .none
        case .moreButtonTapped(let f):
            // TODO: 팔로우 - 더보기
            return .none
        }
    }
}

public extension SocialTabFeature.State {
    enum CurrentTab: String, CaseIterable, Identifiable {
        public var id: String { self.rawValue }
        
        case follower
        case following
    }
}

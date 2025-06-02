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
        public var socialFriends: [SocialFriend] = SocialFriend.dummy()
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
        }
    }
}

public extension SocialTabFeature.State {
    enum CurrentTab: String, Hashable {
        case follower = "팔로워"
        case following = "팔로잉"
        
        public var emptyListDescription: String {
            switch self {
            case .follower:
                "아직 나를 팔로우한 친구가 없어요.\n지금 QR코드를 공유하고, 나를 팔로우할 친구를 만나보세요!"
            case .following:
                "관심 있는 친구를 팔로우 하면\n더 다양한 활동을 볼 수 있어요."
            }
        }
    }
}

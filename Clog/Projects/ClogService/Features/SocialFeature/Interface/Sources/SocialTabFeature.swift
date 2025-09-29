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
    @Dependency(\.socialFriendRepository) private var socialRepository
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public var selectedTab: CurrentTab = .follower
        public var followUsers: [SocialFriend] = []
        public var followingUsers: [SocialFriend] = []
        public var recommendFriends: [SocialFriend] = []
        public var profileMoreBottomSheet = ProfileMoreBottomSheet()
        public init() { }
        
        public struct ProfileMoreBottomSheet: Equatable {
            public var show = false
            public var selectedUser: SocialFriend?
        }
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
        case onAppear
        case selectTab(SocialTabFeature.State.CurrentTab)
        case followButtonTapped(SocialFriend)
        case moreButtonTapped(SocialFriend)
        case unfollowFromBottomSheet
    }
    
    public enum InnerAction { }
    public enum AsyncAction {
        case fetchFollowers
        case fetchFollowings
        case responseFollowers([SocialFriend])
        case responseFollowings([SocialFriend])
        case followUser(SocialFriend)
        case unfollowUser(SocialFriend)
        case updatedFollow(SocialFriend?)
    }
    public enum ScopeAction { }
    public enum DelegateAction { }
    
    public var body: some Reducer<State, Action> {
        
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .view(let action):
                return viewCore(&state, action)
            case .async(let action):
                return asyncCore(&state, action)
            default:
                return .none
            }
        }
    }
    
    func viewCore(_ state: inout State, _ action: View) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .merge(
                .run { send in
                    await send(.async(.fetchFollowers))
                },
                .run { send in
                    await send(.async(.fetchFollowings))
                }
            )
        case .selectTab(let tab):
            state.selectedTab = tab
            return .none
        case .followButtonTapped(let user):
            return .run { send in
                await send(.async(user.isFollowing ? .unfollowUser(user) : .followUser(user)))
            }
        case .moreButtonTapped(let user):
            state.profileMoreBottomSheet.show = true
            state.profileMoreBottomSheet.selectedUser = user
            return .none
        case .unfollowFromBottomSheet:
            guard let user = state.profileMoreBottomSheet.selectedUser else { return .none }
            state.profileMoreBottomSheet.show = false
            state.profileMoreBottomSheet.selectedUser = nil
            return .run { send in
                await send(.async(.unfollowUser(user)))
            }
        }
    }
    
    func asyncCore(
        _ state: inout State,
        _ action: AsyncAction
    ) -> Effect<Action> {
        switch action {
        case .fetchFollowers:
            return .run { send in
                let followers = try? await socialRepository.fetchFollowers()
                await send(.async(.responseFollowers(followers ?? [])))
            }
        case .fetchFollowings:
            return .run { send in
                let followings = try? await socialRepository.fetchFollowings()
                await send(.async(.responseFollowings(followings ?? [])))
            }
        case .responseFollowers(let users):
            state.followUsers = users
            return .none
        case .responseFollowings(let users):
            state.followingUsers = users
            return .none
            
        case .followUser(let user):
            return .run { send in
                let user = try? await socialRepository.followUser(user: user)
                await send(.async(.updatedFollow(user)))
            }
        case .unfollowUser(let user):
            return .run { send in
                let user = try? await socialRepository.unfollowUser(user: user)
                await send(.async(.updatedFollow(user)))
            }
        case .updatedFollow(let user):
            guard let user else { return .none }
            if user.isFollowing {
                state.followingUsers.append(user)
            } else {
                state.followingUsers.removeAll(where: { $0.id == user.id })
            }
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

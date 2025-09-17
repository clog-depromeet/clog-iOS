//
//  SocialFeature.swift
//  SocialFeature
//
//  Created by 강현준 on 5/16/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import ComposableArchitecture
import SocialDomain
import Core

@Reducer
public struct SocialFeature {
    @Dependency(\.socialFriendRepository) private var socialRepository
    @Dependency(\.searchSocialFriendRepository) private var searchRepository
    
    @ObservableState
    public struct State: Equatable {
        
        public var socialTabState: SocialTabFeature.State = .init()
        public var searchBottomSheet = SearchBottomSheet()
        public var followerUsers = [SocialFriend]()
        public init() { }
        
        public struct SearchBottomSheet: Equatable {
            public var show = false
            public var searchText = ""
            public var result: [SocialFriend] = []
        }
    }
    
    public enum Action: BindableAction, FeatureAction, ViewAction {
        case binding(BindingAction<State>)
        case view(View)
        case inner(InnerAction)
        case async(AsyncAction)
        case scope(ScopeAction)
        case delegate(DelegateAction)
        case socialTabAction(SocialTabFeature.Action)
    }
    
    public enum View {
        case didTapSearchButton
        case searchTextChanged(String)
        case didTapFollowButton(SocialFriend)
    }
    
    public enum InnerAction { }
    
    public enum AsyncAction {
        case searchFriends(String)
        case searchFriendsResponse(Result<[SocialFriend], Error>)
        case followUser(SocialFriend)
        case unfollowUser(SocialFriend)
        case followResponse(Result<SocialFriend, Error>)
    }
    
    public enum ScopeAction {}
    public enum DelegateAction {}
    
    private enum CancelID { case search }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.socialTabState, action: \.socialTabAction) {
            SocialTabFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .view(let action):
                return viewCore(&state, action)
            case .async(let action):
                return asyncCore(&state, action)
            case .socialTabAction:
                return .none
            case .binding, .inner, .scope, .delegate:
                return .none
            }
        }
    }
}

extension SocialFeature {
    func reducerCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .socialTabAction:
            return .none
            
        case .binding(_):
            return .none
            
        case .view(let action):
            return viewCore(&state, action)
            
        case .inner(let action):
            return innerCore(&state, action)
            
        case .async(let action):
            return asyncCore(&state, action)
            
        case .scope(let action):
            return scopeCore(&state, action)
            
        case .delegate(let action):
            return delegateCore(&state, action)
        }
    }
    
    // MARK: - View Core
    func viewCore(
        _ state: inout State,
        _ action: View
    ) -> Effect<Action> {
        switch action {
        case .didTapSearchButton:
            state.searchBottomSheet.show = true
            return .none
            
        case let .searchTextChanged(keyword):
            print(keyword)
            state.searchBottomSheet.searchText = keyword
            
            if keyword.isEmpty || keyword.count < 2 {
                state.searchBottomSheet.result = []
                return .cancel(id: CancelID.search)
            }
            
            return .run { send in
                try await Task.sleep(nanoseconds: 500_000_000)
                await send(.async(.searchFriends(keyword)))
            }
            .cancellable(id: CancelID.search)
            
        case .didTapFollowButton(let user):
            if user.isFollowing {
                return .run { send in
                    await send(.async(.unfollowUser(user)))
                }
            } else {
                return .run { send in
                    await send(.async(.followUser(user)))
                }
            }
        }
    }
    
    // MARK: - Inner Core
    func innerCore(
        _ state: inout State,
        _ action: InnerAction
    ) -> Effect<Action> { }
    
    // MARK: - Async Core
    func asyncCore(
        _ state: inout State,
        _ action: AsyncAction
    ) -> Effect<Action> {
        switch action {
        case let .searchFriends(keyword):
            return .run { send in
                do {
                    let friends = try await searchRepository.loadFirstPage(keyword: keyword)
                    await send(.async(.searchFriendsResponse(.success(friends))))
                } catch {
                    await send(.async(.searchFriendsResponse(.failure(error))))
                }
            }
            
        case let .searchFriendsResponse(.success(friends)):
            state.searchBottomSheet.result = friends
            return .none
            
        case let .searchFriendsResponse(.failure(error)):
            state.searchBottomSheet.result = []
            return .none
            
        case .followUser(let user):
            return .run { send in
                do {
                    let user = try await socialRepository.followUser(user: user)
                    await send(.async(.followResponse(.success(user))))
                } catch {
                    await send(.async(.followResponse(.failure(error))))
                }
            }
            
        case .unfollowUser(let user):
            return .run { send in
                do {
                    let user = try await socialRepository.unfollowUser(user: user)
                    await send(.async(.followResponse(.success(user))))
                } catch {
                    await send(.async(.followResponse(.failure(error))))
                }
            }
            
        case .followResponse(.success(let user)):
            if let index = state.searchBottomSheet.result.firstIndex(where: { $0.id == user.id }) {
                state.searchBottomSheet.result[index] = user
            }
            return .none
            
        case .followResponse(.failure(let error)):
            return .none
        }
    }
    
    // MARK: - Scope Core
    func scopeCore(
        _ state: inout State,
        _ action: ScopeAction
    ) -> Effect<Action> { }
    
    // MARK: - Delegate Core
    func delegateCore(
        _ state: inout State,
        _ action: DelegateAction
    ) -> Effect<Action> { }
}

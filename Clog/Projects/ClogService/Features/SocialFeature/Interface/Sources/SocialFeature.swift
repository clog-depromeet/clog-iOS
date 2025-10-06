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
import AccountDomain
import Core
import UIKit

@Reducer
public struct SocialFeature {
    @Dependency(\.socialFriendRepository) private var socialRepository
    @Dependency(\.searchSocialFriendRepository) private var searchRepository
    @Dependency(\.accountUseCase) private var accountUseCase
    
    @ObservableState
    public struct State: Equatable {
        
        public var socialTabState: SocialTabFeature.State = .init()
        public var searchBottomSheet = SearchBottomSheet()
        public var followerUsers = [SocialFriend]()
        public var id: Int? = nil
        public var name: String? = nil
        public var height: Int? = nil
        public var armLength: Int? = nil
        public var sns: String? = nil
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
        case onAppear
        case didTapEditProfileButton
        case didTapInstagramButton
        case didTapSearchButton
        case searchTextChanged(String)
        case didTapFollowButton(SocialFriend)
    }
    
    public enum InnerAction {
        case fetchMyProfileResponse(User)
    }
    
    public enum AsyncAction {
        case fetchMyProfile
        case searchFriends(String)
        case searchFriendsResponse(Result<[SocialFriend], Error>)
        case followUser(SocialFriend)
        case unfollowUser(SocialFriend)
        case followResponse(Result<SocialFriend, Error>)
    }
    
    public enum ScopeAction {}
    public enum DelegateAction {
        case navigateToReport(SocialFriend)
        case navigateToProfileEditor
    }
    
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
            case .inner(let action):
                return innerCore(&state, action)
            case .async(let action):
                return asyncCore(&state, action)
            case .socialTabAction(.delegate(let delegateAction)):
                return handleSocialTabDelegate(&state, delegateAction)
            case .socialTabAction:
                return .none
            case .binding, .scope, .delegate:
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
        case .onAppear:
            return .send(.async(.fetchMyProfile))
            
        case .didTapEditProfileButton:
            return .send(.delegate(.navigateToProfileEditor))

        case .didTapInstagramButton:
            guard let urlString = state.sns,
                  let url = URL(string: urlString) else {
                return .none
            }
            return .run { _ in
                await MainActor.run {
                    UIApplication.shared.open(url)
                }
            }

        case .didTapSearchButton:
            state.searchBottomSheet.show = true
            return .none
            
        case let .searchTextChanged(keyword):
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
            return .run { send in
                await send(.async(user.isFollowing ? .unfollowUser(user) : .followUser(user)))
            }
        }
    }
    
    // MARK: - Inner Core
    func innerCore(
        _ state: inout State,
        _ action: InnerAction
    ) -> Effect<Action> {
        switch action {
        case .fetchMyProfileResponse(let user):
            state.id = user.id
            state.name = user.name
            state.height = user.height
            state.armLength = user.armSpan
            state.sns = user.instagramUrl
            return .none
        }
    }
    
    // MARK: - Async Core
    func asyncCore(
        _ state: inout State,
        _ action: AsyncAction
    ) -> Effect<Action> {
        switch action {
        case .fetchMyProfile:
            return .run { send in
                do {
                    let user = try await accountUseCase.fetchAccount()
                    await send(.inner(.fetchMyProfileResponse(user)))
                } catch {
                    // TODO: 에러 처리
                }
            }
            
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
            
            if user.isFollowing {
                if !state.socialTabState.followingUsers.contains(where: { $0.id == user.id }) {
                    state.socialTabState.followingUsers.append(user)
                }
            } else {
                state.socialTabState.followingUsers.removeAll { $0.id == user.id }
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
    ) -> Effect<Action> {
        return .none
    }
    
    // MARK: - Social Tab Delegate
    func handleSocialTabDelegate(
        _ state: inout State,
        _ action: SocialTabFeature.DelegateAction
    ) -> Effect<Action> {
        switch action {
        case .navigateToReport(let friend):
            return .send(.delegate(.navigateToReport(friend)))
        }
    }
}

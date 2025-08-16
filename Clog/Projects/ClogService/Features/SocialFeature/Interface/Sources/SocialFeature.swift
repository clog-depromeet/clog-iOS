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

@Reducer
public struct SocialFeature {
    @Dependency(\.socialFriendRepository) private var socialRepository
    @Dependency(\.searchSocialFriendRepository) private var searchRepository
    
    @ObservableState
    public struct State: Equatable {
        
        public var socialTabState: SocialTabFeature.State = .init()
        public var searchBottomSheet = SearchBottomSheet()
        public init() { }
        
        public struct SearchBottomSheet: Equatable {
            public var show = false
            public var searchText = ""
            public var result: [SocialFriend] = []
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case socialTabAction(SocialTabFeature.Action)
        case didTapSearchButton
        case searchTextChanged(String)
        case searchFriendsResponse(Result<[SocialFriend], Error>)
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
            case .didTapSearchButton:
                state.searchBottomSheet.show = true
                return .none
                
            case let .searchTextChanged(keyword):
                if keyword.isEmpty {
                    state.searchBottomSheet.result = []
                    return .cancel(id: CancelID.search)
                }
                
                guard keyword.count >= 2 else {
                    state.searchBottomSheet.result = []
                    return .cancel(id: CancelID.search)
                }
                
                return .run { send in
                    print("검색어: \(keyword)")
                    do {
                        let friends = try await searchRepository.loadFirstPage(keyword: keyword)
                        await send(.searchFriendsResponse(.success(friends)))
                    } catch {
                        await send(.searchFriendsResponse(.failure(error)))
                    }
                }
                .debounce(
                    id: CancelID.search,
                    for: .seconds(0.5),
                    scheduler: DispatchQueue.main
                )
                
            case let .searchFriendsResponse(.success(friends)):
                state.searchBottomSheet.result = friends
                return .none
                
            case let .searchFriendsResponse(.failure(error)):
                state.searchBottomSheet.result = []
                print("Search error: \(error)")
                return .none
                
            default: return .none
            }
        }
    }
}


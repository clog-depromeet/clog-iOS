//
//  SocialFeature.swift
//  SocialFeature
//
//  Created by 강현준 on 5/16/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct SocialFeature {
    @Dependency(\.socialFriendRepository) private var socialRepository
    @Dependency(\.searchSocialFriendUseCase) private var searchUseCase
    
    @ObservableState
    public struct State: Equatable {
        
        public var socialTabState: SocialTabFeature.State = .init()
        public var searchBottomSheet = SearchBottomSheet()
        public init() { }
        
        public struct SearchBottomSheet: Equatable {
            public var show = false
            public var searchText = ""
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case socialTabAction(SocialTabFeature.Action)
        case didTapSearchButton
    }
    
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
                
            default: return .none
            }
        }
    }
}


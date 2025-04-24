//
//  FolderTabFeature.swift
//  FolderTabFeatureFeature
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct FolderTabFeature {
    public enum TabType: String, CaseIterable {
        case folder = "폴더"
        case calendar = "캘린더"
    }
    
    @ObservableState
    public struct State: Equatable {
        var selectedTab: TabType = .folder
        public init() {
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case tabBarTapped(TabType)
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .tabBarTapped(let type):
                state.selectedTab = type
                return .none
            default:
                return .none
            }
        }
    }
}

//
//  AddAttemptsFeature.swift
//  AddAttemptsFeature
//
//  Created by soi on 5/24/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Core

import ComposableArchitecture
import _PhotosUI_SwiftUI

@Reducer
public struct AddAttemptsFeature {
    
    @ObservableState
    public struct State: Equatable {
        var videoSelections: [PhotosPickerItem] = []
        // FIXME: showPhotoPicker 추가시 EXC_BAD_ACCESS 발생
//        var showPhotoPicker: Bool = false
        public init() {}
    }
    
    public enum Action: FeatureAction, ViewAction, BindableAction {
        case binding(BindingAction<State>)
        case view(View)
        case inner(InnerAction)
        case async(AsyncAction)
        case scope(ScopeAction)
        case delegate(DelegateAction)
    }
    
    public enum View {
        case onAppear
        case videoSelectionChanged([PhotosPickerItem])
    }
    
    public enum InnerAction { }
    public enum AsyncAction { }
    public enum ScopeAction { }
    public enum DelegateAction { }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce(reducerCore)
    }
    
    public init() {}
}

extension AddAttemptsFeature {
    func reducerCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        
        switch action {
        case .binding:
            return .none
            
        case .view(let action):
            return viewCore(&state, action)
        }
    }
    
    func viewCore(
        _ state: inout State,
        _ action: View
    ) -> Effect<Action> {
        switch action {
        case .onAppear:
//            state.showPhotoPicker = true
            return .none
            
        case let .videoSelectionChanged(selections):
            state.videoSelections = selections
            return .none
        }
    }
}

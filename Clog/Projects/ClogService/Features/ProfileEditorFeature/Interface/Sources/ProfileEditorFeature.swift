//
//  ProfileEditorFeature.swift
//  ProfileEditorFeatureInterface
//
//  Created by Junyoung on 5/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture

import Core

@Reducer
public struct ProfileEditorFeature {
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public var gender: Gender = .male
        public var nickname: String = ""
        public var errorText: String = ""
        public var height: String = ""
        public var armLength: String = ""
        public var sns: String = ""
        
        public var nicknameFocus: Bool = false
        public var heightFocus: Bool = false
        public var armLengthFocus: Bool = false
        public var snsFocus: Bool = false
        
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
        case backButtonTapped
        case genderTapped(Gender)
        case focusOut
    }
    public enum InnerAction { }
    public enum AsyncAction { }
    public enum ScopeAction { }
    public enum DelegateAction { }
    
    public enum Gender: Equatable {
        case male
        case female
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce(reducerCore)
    }
}

extension ProfileEditorFeature {
    // MARK: - Reducer Core
    func reducerCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
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
        case .backButtonTapped:
            return .none
            
        case .genderTapped(let gender):
            state.gender = gender
            return .none
            
        case .focusOut:
            state.nicknameFocus = false
            state.heightFocus = false
            state.armLengthFocus = false
            state.snsFocus = false
            return .none
        }
    }
    
    // MARK: - Inner Core
    func innerCore(
        _ state: inout State,
        _ action: InnerAction
    ) -> Effect<Action> {
        switch action {
            
        }
    }
    
    // MARK: - Async Core
    func asyncCore(
        _ state: inout State,
        _ action: AsyncAction
    ) -> Effect<Action> {
        switch action {
            
        }
    }
    
    // MARK: - Scope Core
    func scopeCore(
        _ state: inout State,
        _ action: ScopeAction
    ) -> Effect<Action> {
        switch action {
            
        }
    }
    
    // MARK: - Delegate Core
    func delegateCore(
        _ state: inout State,
        _ action: DelegateAction
    ) -> Effect<Action> {
        switch action {
            
        }
    }
}

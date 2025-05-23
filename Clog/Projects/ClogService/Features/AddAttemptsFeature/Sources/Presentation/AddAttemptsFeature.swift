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

@Reducer
public struct AddAttemptsFeature {
    
    @ObservableState
    public struct State: Equatable {
        
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
        
    }
    
    public enum InnerAction { }
    public enum AsyncAction { }
    public enum ScopeAction { }
    public enum DelegateAction { }
    
    
    public init() {}
}

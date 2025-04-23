//
//  OnboardingFeature.swift
//  OnboardingFeature
//
//  Created by Junyoung on 3/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct OnboardingFeature {
    @ObservableState
    public struct State: Equatable {
        var selected: Int = 0
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case startTapped
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce(reducerCore)
    }
}

extension OnboardingFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        default:
            return .none
        }
    }
}

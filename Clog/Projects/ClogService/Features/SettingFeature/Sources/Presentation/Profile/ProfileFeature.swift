//
//  ProfileFeature.swift
//  SettingFeature
//
//  Created by Junyoung on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct ProfileFeature {
    @ObservableState
    public struct State: Equatable {
        
    }
    
    public enum Action: Equatable {
        
    }
    
    init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce(reducerCore)
    }
}

extension ProfileFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        
    }
}

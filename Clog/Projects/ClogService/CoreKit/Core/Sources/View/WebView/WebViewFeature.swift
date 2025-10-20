//
//  WebViewFeature.swift
//  Core
//
//  Created by Junyoung on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct WebViewFeature {
    @ObservableState
    public struct State: Equatable {
        var urlString: String
        
        public init(urlString: String) {
            self.urlString = urlString
        }
    }
    
    public enum Action: Equatable {
        case backButtonTapped
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce(reducerCore)
    }
}

extension WebViewFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        default:
            return .none
        }
    }
}

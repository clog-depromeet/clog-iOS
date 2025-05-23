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
    
    @ObservableState
    public struct State: Equatable {
        
        var socialTabState: SocialTabFeature.State = .init()
        
        public init() { }
        
    }
    
    public enum Action {
        case socialTabAction(SocialTabFeature.Action)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.socialTabState, action: \.socialTabAction) {
            SocialTabFeature()
        }
    }
}


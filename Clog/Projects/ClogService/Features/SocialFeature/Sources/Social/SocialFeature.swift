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
    
    public struct State: Equatable {
        
        public init() { }
        
    }
    
    public enum Action { }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            return .none
        }
    }
    
}

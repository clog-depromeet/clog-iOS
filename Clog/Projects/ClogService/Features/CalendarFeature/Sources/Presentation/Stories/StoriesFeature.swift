//
//  StoriesFeature.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture
import StoryDomain

@Reducer
public struct StoriesFeature {
    @ObservableState
    public struct State: Equatable {
        var story: Story = Story(
            id: 0,
            totalDurationMs: 0,
            problems: []
        )
    }
    
    public enum Action: Equatable {
        case updateStory(Story)
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce(reducerCore)
    }
}

extension StoriesFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .updateStory(let story):
            state.story = story
            return .none
        }
    }
}

//
//  ProblemCheckCompleteBottomSheetFeature.swift
//  VideoFeature
//
//  Created by Junyoung on 3/29/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture
import StoryDomain
import FolderDomain

@Reducer
public struct ProblemCheckCompleteBottomSheetFeature {
    @Dependency(\.fetchStoryUseCase) var fetchStoryUseCase
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        let storyId: Int
        var story: Story = .init(
            id: -999,
            totalDurationMs: 0,
            problems: []
        )
        
        public init(storyId: Int) {
            self.storyId = storyId
        }
    }
    
    public enum Action {
        case onAppear
        case itemDeleteTapped(Int)
        
        // Fetch Story
        case fetchSuccess(Story)
        case fetchFailure(Error)
        
        // Delete Attempt
        case attemptDeleteSuccess(Int)
        case attemptDeleteFailure(Error)
        
        case finishTapped
    }
    
    public var body: some Reducer<State, Action> {
        Reduce(reducerCore)
    }
}

extension ProblemCheckCompleteBottomSheetFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return fetchStory(state.storyId)
            
        case .fetchSuccess(let response):
            state.story = response
            return .none
        default:
            return .none
        }
    }
    
    func fetchStory(_ storyId: Int) -> Effect<Action> {
        .run { send in
            do {
                let response = try await fetchStoryUseCase.fetchStory(storyId)
                await send(.fetchSuccess(response))
            } catch {
                await send(.fetchFailure(error))
            }
        }
    }
}

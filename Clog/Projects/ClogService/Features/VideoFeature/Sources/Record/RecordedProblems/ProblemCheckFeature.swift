//
//  ProblemCheckFeature.swift
//  VideoFeature
//
//  Created by Junyoung on 3/29/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture
import StoryDomain

@Reducer
public struct ProblemCheckFeature {
    @Dependency(\.fetchStoryUseCase) private var fetchStoryUseCase
    @Dependency(\.attemptUseCase) private var attemptUseCase
    
    @ObservableState
    public struct State: Equatable {
        let storyId: Int
        var problems: [StoryProblem] = []
        var isLoading: Bool = false
        
        public init(storyId: Int) {
            self.storyId = storyId
        }
    }
    
    public enum Action {
        case onAppear
        case deleteProblemTapped(StoryAttempt)
        
        case fetchSuccess(Story)
        case deleteSuccess(StoryAttempt)
        
        case handleError(Error)
    }
    
    init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce(reducerCore)
    }
}

extension ProblemCheckFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.isLoading = true
            return fetchStory(storyId: state.storyId)
            
        case .deleteProblemTapped(let attempt):
            state.isLoading = true
            return deleteAttempt(attempt: attempt)
            
        case .fetchSuccess(let response):
            state.isLoading = false
            state.problems = response.problems
            return .none
            
        case .deleteSuccess(let attempt):
            state.isLoading = false
            return fetchStory(storyId: state.storyId)
            
        case .handleError(let error):
            state.isLoading = false
            print(error)
            return .none
            
        default:
            return .none
        }
    }
    
    func fetchStory(storyId: Int) -> Effect<Action> {
        .run { send in
            do {
                let response = try await fetchStoryUseCase.fetchStory(storyId)
                await send(.fetchSuccess(response))
            } catch {
                await send(.handleError(error))
            }
        }
    }
    
    func deleteAttempt(attempt: StoryAttempt) -> Effect<Action> {
        .run { send in
            do {
                try await attemptUseCase.delete(attemptId: attempt.id)
                await send(.deleteSuccess(attempt))
            } catch {
                await send(.handleError(error))
            }
        }
    }
}

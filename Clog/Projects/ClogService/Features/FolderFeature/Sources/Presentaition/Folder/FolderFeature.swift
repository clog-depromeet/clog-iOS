//
//  FolderFeature.swift
//  FolderFeatureFeature
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture
import FolderDomain
import Shared

@Reducer
public struct FolderFeature {
    @Dependency(\.filteredAttemptsUseCase) private var filteredAttemptsUseCase
    @Dependency(\.fetchFilterableAttemptInfoUseCase) private var fetchFilterableAttemptInfoUseCase
    
    @ObservableState
    public struct State: Equatable {
        var filterableAttemptInfo: FilterableAttemptInfo?
        var attempts = [Attempt]()
        let chips = SelectedChip.allCases
        var attemptFilter = AttemptFilter()
        var viewState = ViewState.loading
        var showSelectGradeBottomSheet = false
        var showSelectCragBottomSheet = false
        var searchCragName = ""
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case completeChipTapped
        case failChipTapped
        case gradeChipTapped
        case cragChipTapped
        
        case getFilterableInfo(_ data: FilterableAttemptInfo)
        case didSelectCrag(_ crag: Crag)
        case didSelectGrade(_ grade: Grade)
        case getFilteredAttempts(_ attempts: [Attempt])
        
        case setViewState(_ state: ViewState)
        case moveToAttempt(_ attemptId: Int)
        case fail
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .onAppear:
                return fetchInitialData(state.attemptFilter)
                
            case .completeChipTapped:
                return handleChipToggle(state: &state, result: .complete)
                
            case .failChipTapped:
                return handleChipToggle(state: &state, result: .fail)
                
            case .gradeChipTapped:
                return handleGradeChipTap(state: &state)
                
            case .cragChipTapped:
                return handleCragChipTap(state: &state)
                
            case .getFilterableInfo(let info):
                state.filterableAttemptInfo = info
                return .none
                
            case .didSelectCrag(let crag):
                return handleCragSelection(state: &state, crag: crag)
                
            case .didSelectGrade(let grade):
                return handleGradeSelection(state: &state, grade: grade)
                
            case .setViewState(let viewState):
                state.viewState = viewState
                return .none
                
            case .getFilteredAttempts(let attempts):
                state.attempts = attempts
                return .none
                
            case .moveToAttempt, .fail:
                return .none
            }
        }
    }
    public init() {}
}

private extension FolderFeature {
    
    private func fetchInitialData(_ filter: AttemptFilter) -> Effect<Action> {
        return .run { send in
            do {
                async let requestFilterableInfo = fetchFilterableAttemptInfoUseCase.execute()
                async let allAttempts = filteredAttemptsUseCase.execute(filter)
                
                let (filterableInfo, attemptsResult) = try await (requestFilterableInfo, allAttempts)
                
                await send(.getFilterableInfo(filterableInfo))
                await send(.getFilteredAttempts(attemptsResult))
                await send(.setViewState(.loaded))
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func fetchFilteredAttempts(_ filter: AttemptFilter) -> Effect<Action> {
        return .run { send in
            do {
                let attempts = try await filteredAttemptsUseCase.execute(filter)
                await send(.getFilteredAttempts(attempts))
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
}

private extension FolderFeature {
    private func handleChipToggle(state: inout State, result: AttemptResult?) -> Effect<Action> {
        let filter = state.attemptFilter.toggleResult(result)
        state.attemptFilter = filter
        return fetchFilteredAttempts(filter)
    }
    
    private func handleGradeChipTap(state: inout State) -> Effect<Action> {
        guard state.attemptFilter.grade != nil else {
            state.showSelectGradeBottomSheet = true
            return .none
        }
        
        let filter = state.attemptFilter.updateGrade(nil)
        state.attemptFilter = filter
        return fetchFilteredAttempts(filter)
    }
    
    private func handleCragChipTap(state: inout State) -> Effect<Action> {
        guard state.attemptFilter.crag != nil else {
            state.searchCragName = ""
            state.showSelectCragBottomSheet = true
            return .none
        }
        
        let filter = state.attemptFilter.updateCrag(nil)
        state.attemptFilter = filter
        return fetchFilteredAttempts(filter)
    }
    
    private func handleCragSelection(state: inout State, crag: Crag) -> Effect<Action> {
        let filter = state.attemptFilter.updateCrag(crag)
        state.attemptFilter = filter
        state.showSelectCragBottomSheet = false
        return fetchFilteredAttempts(filter)
    }
    
    private func handleGradeSelection(state: inout State, grade: Grade) -> Effect<Action> {
        let filter = state.attemptFilter.updateGrade(grade)
        state.attemptFilter = filter
        state.showSelectGradeBottomSheet = false
        return fetchFilteredAttempts(filter)
    }
}

// MARK: - Supporting Enums
extension FolderFeature {
    public enum ViewState: Equatable {
        case loading
        case loaded
    }
    
    enum SelectedChip: Hashable, CaseIterable {
        case complete
        case fail
        case grade
        case crag
    }
}

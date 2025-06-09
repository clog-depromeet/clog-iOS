//
//  AddAttemptsFeature.swift
//  AddAttemptsFeature
//
//  Created by soi on 5/24/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Core
import DesignKit
import Shared
import Domain

import ComposableArchitecture
import _PhotosUI_SwiftUI

@Reducer
public struct AddAttemptsFeature {
    
    @Dependency(\.nearByCragUseCase) private var cragUseCase
    
    @ObservableState
    public struct State: Equatable {
        var videoSelections: [PhotosPickerItem] = []
        var loadedVideos: [VideoAssetMetadata] = []
        var showPhotoPicker: Bool = false
        var nearByCragState = CragBottomSheetState()
        
        var loadedVideosTotalDurationString: String {
            let duration = loadedVideos.map(\.duration).reduce(0, +)
            return Self.durationFormatter.string(from: duration) ?? "00:00:00"
        }
        
        public init() {}
        
        public struct CragBottomSheetState: Equatable {
            var showCragBottomSheet = false
            var crags: [DesignCrag] = []
            var selectedCrag: Crag? = nil
        }
        
        private static let durationFormatter: DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = [.pad]
            return formatter
        }()
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
        case onAppear
        case videoSelectionChanged([PhotosPickerItem])
        case photoPickerDismissed
        case cragBottomSheet(CragBottomSheetAction)
        case didTapCragTitleView
        
        public enum CragBottomSheetAction {
            case didTapSaveButton(DesignCrag)
            case didTapSkipButton
            case didNearEnd
            case didChangeSearchText(String)
        }
    }
    
    public enum InnerAction {
        case didLoadVideos([VideoAssetMetadata])
    }
    
    public enum AsyncAction {
        case cragBottomSheet(CragBottomSheetAction)
        
        public enum CragBottomSheetAction {
            case fetch(_ crags: [Crag])
            case fetchMore(_ crags: [Crag])
        }
    }
    
    public enum ScopeAction { }
    public enum DelegateAction { }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce(reducerCore)
    }
    
    public init() {}
}

// MARK: Reducer Core
extension AddAttemptsFeature {
    func reducerCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        
        switch action {
        case .binding:
            return .none
            
        case .view(let action):
            return viewCore(&state, action)
            
        case .inner(let action):
            return innerCore(&state, action)
            
        case .async(let action):
            return asyncCore(&state, action)
        }
    }
}

// MARK: ViewCore
extension AddAttemptsFeature {
    
    func viewCore(
        _ state: inout State,
        _ action: View
    ) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.showPhotoPicker = true
            return .none
            
        case let .videoSelectionChanged(selections):
            state.videoSelections = selections
            return .run { send in
                let videos = try await loadVideoMetadataList(from: selections)
                await send(.inner(.didLoadVideos(videos)))
            }
            
        case .photoPickerDismissed:
            state.nearByCragState.showCragBottomSheet = true
            return fetchNearByCrags()
            
        case .cragBottomSheet(let action):
            return handleCragBottomSheetViewAction(&state, action)
            
        case .didTapCragTitleView:
            state.nearByCragState.showCragBottomSheet = true
            return .none
        }
        
    }
    
    private func handleCragBottomSheetViewAction(
        _ state: inout State,
        _ action: View.CragBottomSheetAction
    ) -> Effect<Action> {
        switch action {
            
        case .didTapSaveButton(let crag):
            let selectedCrag = Crag(
                id: crag.id,
                name: crag.name,
                address: crag.address
            )
            state.nearByCragState.showCragBottomSheet = false
            state.nearByCragState.selectedCrag = selectedCrag
            return .none
            
        case .didTapSkipButton:
            state.nearByCragState.showCragBottomSheet = false
            return .none
            
        case .didNearEnd:
            return fetchMoreNearByCrags()
            
        case .didChangeSearchText(_):
            return .none
        }
    }
    
    private func loadVideoMetadataList(from selections: [PhotosPickerItem]) async throws -> [VideoAssetMetadata] {
        return try await withThrowingTaskGroup(of: VideoAssetMetadata?.self) { group in
            var results = [VideoAssetMetadata]()
            for item in selections {
                group.addTask {
                    try await VideoAssetLoader.loadVideoMetadata(from: item)
                }
            }
            
            for try await result in group {
                if let result = result {
                    results.append(result)
                }
            }
            
            return results
        }
    }
}

extension AddAttemptsFeature {
    func innerCore(
        _ state: inout State,
        _ action: InnerAction
    ) -> Effect<Action> {
        
        switch action {
        case .didLoadVideos(let videos):
            state.loadedVideos = videos
            return .none
        }
    }
}

// MARK: Async Core
extension AddAttemptsFeature {
    func asyncCore(
        _ state: inout State,
        _ action: AsyncAction
    ) -> Effect<Action> {
        switch action {
        case .cragBottomSheet(let action):
            switch action {
            case .fetch(let crags):
                state.nearByCragState.crags = crags.map {
                    DesignCrag(id: $0.id, name: $0.name, address: $0.address)
                }
                return .none
            case .fetchMore(let crags):
                let crags = crags.map {
                    DesignCrag(id: $0.id, name: $0.name, address: $0.address)
                }
                state.nearByCragState.crags.append(contentsOf: crags)
                return .none
            }
        }
    }
    
    private func fetchNearByCrags(keyword: String = "") -> Effect<Action> {
        return .run { send in
            do {
                let crags = try await cragUseCase.fetch(keyword: keyword, location: nil)
                await send(.async(.cragBottomSheet(.fetch(crags))))
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func fetchMoreNearByCrags() -> Effect<Action> {
        .run { send in
            do {
                let crags = try await cragUseCase.next()
                await send(.async(.cragBottomSheet(.fetchMore(crags))))
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
}

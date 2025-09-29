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
import StoryDomain
import VideoDomain

import ComposableArchitecture
import _PhotosUI_SwiftUI

@Reducer
public struct AddAttemptsFeature {
    
    @Dependency(\.nearByCragUseCase) private var cragUseCase
    @Dependency(\.addProblemsUseCase) private var addProblemsUseCase
    @Dependency(\.videoUseCase) private var videoUseCase
    
    @ObservableState
    public struct State: Equatable {
        @Presents public var showCancelAttemptAlert: AlertState<Action.CancelAddAttempts>?
        
        public var videoSelections: [PhotosPickerItem] = []
        public var selectedVideos: [VideoInfo] = []
        public var showPhotoPicker = false
        public var nearByCragState = CragBottomSheetState()
        public var focusedMemoTextEditor = false
        public var memo = ""
        
        public var totalDurationFormatted: String {
            let total = selectedVideos.map(\.duration).reduce(0, +)
            return Self.durationFormatter.string(from: total) ?? "00:00"
        }
        
        public init() {}
        
        public struct CragBottomSheetState: Equatable {
            public var showCragBottomSheet = false
            public var crags: [DesignCrag] = []
            public var selectedCrag: Crag? = nil
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
        
        case presentedAlert(PresentationAction<CancelAddAttempts>)
        
        @CasePathable
        public enum CancelAddAttempts: Equatable {
            case cancel
            case delete
        }
    }
    
    public enum View {
        case onAppear
        case videoSelectionChanged([PhotosPickerItem])
        case photoPickerDismissed
        case cragBottomSheet(CragBottomSheetAction)
        case didTapCragTitleView
        case didTapBackButton
        case didTapSaveButton
        case didSavedAttempts
        
        public enum CragBottomSheetAction {
            case didTapSaveButton(DesignCrag)
            case didTapSkipButton
            case didNearEnd
            case didChangeSearchText(String)
        }
    }
    
    public enum InnerAction {
        case didLoadVideos([VideoInfo])
    }
    
    public enum AsyncAction {
        case cragBottomSheet(CragBottomSheetAction)
        case postProblems(AddProblems)
        
        public enum CragBottomSheetAction {
            case fetch(_ crags: [Crag])
            case fetchMore(_ crags: [Crag])
        }
    }
    
    public enum ScopeAction { }
    public enum DelegateAction {
        case dismissView
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce(reducerCore)
            .ifLet(\.$showCancelAttemptAlert, action: \.presentedAlert)
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
            
        case .presentedAlert(let action):
            guard case .presented(.delete) = action else {
                return .none
            }
            return .send(.delegate(.dismissView))
            
        case .delegate:
            return .none
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
                let videos = try await loadVideoInfoList(from: selections)
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
            
        case .didTapBackButton:
            state.showCancelAttemptAlert = AlertState {
                TextState("기록 삭제")
            } actions: {
                ButtonState(action: .delete) {
                    TextState("삭제")
                }
                ButtonState(action: .cancel) {
                    TextState("취소")
                }
            } message: {
                TextState("기록을 취소하면 저장되지 않아요 \n기록 추가를 삭제하시나요?")
            }
            return .none
            
        case .didTapSaveButton:
            let oldestDate = state.selectedVideos
                .compactMap { $0.creationDate }
                .min() ?? Date()
            
            let problem = AddProblems(
                date: oldestDate.formattedString("y-MM-dd"),
                cragId: state.nearByCragState.selectedCrag?.id,
                memo: state.memo,
                videos: []
            )
            return .send(.async(.postProblems(problem)))
            
        case .didSavedAttempts:
            // Pop to parent
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
    
    func generateVideoThumbnailURL(from url: URL) -> URL? {
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 1, preferredTimescale: 600)

        guard let cgImage = try? generator.copyCGImage(at: time, actualTime: nil) else {
            return nil
        }

        let uiImage = UIImage(cgImage: cgImage)
        guard let data = uiImage.jpegData(compressionQuality: 0.8) else {
            return nil
        }

        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("jpg")

        do {
            try data.write(to: tempURL)
            return tempURL
        } catch {
            return nil
        }
    }
    
    private func loadVideoInfoList(from selections: [PhotosPickerItem]) async throws -> [VideoInfo] {
        return try await withThrowingTaskGroup(of: VideoInfo?.self) { group in
            var results = [VideoInfo]()
            for item in selections {
                group.addTask {
                    try await VideoLoader.loadVideoInfo(from: item)
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
            state.selectedVideos = videos
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
            
        case .postProblems(let problems):
            return .run { [selectedVideos = state.selectedVideos] send in
                do {
                    let uploadedMap: [String: String] = try await withThrowingTaskGroup(of: (String, String)?.self) { group in
                        for video in selectedVideos {
                            group.addTask {
                                guard let url = try await postThumbnail(
                                    id: video.id,
                                    image: video.thumbnail
                                ) else { return nil }
                                return (video.id, url)
                            }
                        }
                        
                        var result: [String: String] = [:]
                        for try await pair in group {
                            if let (id, url) = pair {
                                result[id] = url
                            }
                        }
                        return result
                    }

                    let videos: [VideoRequest] = selectedVideos.map { video in
                        VideoRequest(
                            localPath: video.id,
                            thumbnailUrl: uploadedMap[video.id],
                            durationMs: Int(video.duration),
                            stamps: []
                        )
                    }

                    let finalProblem = AddProblems(
                        date: problems.date,
                        cragId: problems.cragId,
                        memo: problems.memo,
                        videos: videos
                    )
                    
                    try await addProblemsUseCase.execute(finalProblem)
                    await send(.view(.didSavedAttempts))
                } catch {
                    // TODO: Toast Message
                }
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
    
    private func postThumbnail(id: String, image: UIImage?) async throws -> String? {
        guard let image,
              let imageData = image.resizedPNGData() else {
            return nil
        }
        
        let fileName = "\(id)_thumbnail.jpg"
        let mimeType = "image/png"
        
        return try await videoUseCase.execute(
            fileName: fileName,
            mimeType: mimeType,
            value: imageData
        )
    }
}

extension AddAttemptsFeature {
    func delegateCore() -> Effect<Action> {
        return .none
    }
}

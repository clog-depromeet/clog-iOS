//
//  CompletionReportFeature.swift
//  CompletionReportFeature
//
//  Created by Junyoung on 3/31/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture
import StoryDomain
import SwiftUI
import Photos

@Reducer
public struct CompletionReportFeature {
    @Dependency(\.fetchStoryUseCase) private var fetchStoryUseCase
    
    @ObservableState
    public struct State: Equatable {
        let storyId: Int
        var summary: StorySummary = StorySummary.init()
        
        var sharedURL: URL?
        var sharedShow: Bool = false
        
        public init(storyId: Int) {
            self.storyId = storyId
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case finish
        
        case shareButtonTapped(UIImage)
        case shareSetURL(URL)
        
        case fetchSummarySuccess(StorySummary)
        case errorHandler(Error)
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce(reducerCore)
    }
    
    public init() {}
}

extension CompletionReportFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return fetchSummary(state.storyId)
            
        case .fetchSummarySuccess(let summary):
            state.summary = summary
            return .none
            
        case .shareButtonTapped(let image):
            print(image)
            return .run { [state] send in
                if let url = state.sharedURL {
                    await send(.shareSetURL(url))
                } else {
                    let asset = try await saveImageToPhotos(image)
                    let url = try await fetchImageDataURL(from: asset)
                    await send(.shareSetURL(url))
                }
            }
            
        case .shareSetURL(let url):
            state.sharedURL = url
            state.sharedShow = true
            return .none

        default:
            return .none
        }
    }
    
    private func fetchSummary(_ storyId: Int) -> Effect<Action> {
        .run { send in
            let summary = try await fetchStoryUseCase.fetchSummary(storyId)
            await send(.fetchSummarySuccess(summary))
        }
    }
    
    // UIImage를 PHAsset에 저장하는 비동기 함수
    func saveImageToPhotos(_ image: UIImage) async throws -> PHAsset {
        return try await withCheckedThrowingContinuation { continuation in
            var assetPlaceholder: PHObjectPlaceholder?

            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                assetPlaceholder = request.placeholderForCreatedAsset
            }) { success, error in
                if success, let localIdentifier = assetPlaceholder?.localIdentifier {
                    let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
                    if let asset = assetResult.firstObject {
                        continuation.resume(returning: asset)
                    } else {
                        continuation.resume(throwing: NSError(domain: "PHAssetError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch asset."]))
                    }
                } else {
                    continuation.resume(throwing: error ?? NSError(domain: "PHAssetError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to save image."]))
                }
            }
        }
    }

    // 저장된 PHAsset에서 URL 가져오기
    func fetchImageDataURL(from asset: PHAsset) async throws -> URL {
        return try await withCheckedThrowingContinuation { continuation in
            let resource = PHAssetResource.assetResources(for: asset).first
            let options = PHAssetResourceRequestOptions()
            options.isNetworkAccessAllowed = true
            
            guard let resource else {
                continuation.resume(throwing: NSError(domain: "PHAssetError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No asset resource found."]))
                return
            }
            
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).jpg")
            
            PHAssetResourceManager.default().writeData(for: resource, toFile: tempURL, options: options) { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: tempURL)
                }
            }
        }
    }
}

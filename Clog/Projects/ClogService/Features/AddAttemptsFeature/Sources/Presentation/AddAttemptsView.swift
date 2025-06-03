//
//  AddAttemptsView.swift
//  AddAttemptsFeature
//
//  Created by soi on 5/24/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import PhotosUI

import DesignKit

import ComposableArchitecture

@ViewAction(for: AddAttemptsFeature.self)
public struct AddAttemptsView: View {
    @Bindable public var store: StoreOf<AddAttemptsFeature>
    
    private let size = (UIScreen.main.bounds.width / 2) - 20
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    public var body: some View {
        makeBodyView()
            .background(Color.clogUI.gray800)
            .onAppear {
                send(.onAppear)
            }
            .fullScreenCover(
                isPresented: $store.showPhotoPicker,
                onDismiss: {
                    send(.photoPickerDismissed)
                }
            ) {
                makePhotoPickerView()
            }
            .showCragBottomSheet(
                isPresented: $store.nearByCragState.showCragBottomSheet,
                didTapSaveButton: { crag in
                    send(.cragBottomSheet(.didTapSaveButton(crag)))
                },
                didTapSkipButton: {
                    send(.cragBottomSheet(.didTapSkipButton))
                },
                didNearEnd: {
                    send(.cragBottomSheet(.didNearEnd))
                },
                didChangeSearchText: { searchText in
                    send(.cragBottomSheet(.didChangeSearchText(searchText)))
                },
                matchesPattern: { crag, searchText in
                    false
                },
                crags: $store.nearByCragState.crags
            )
    }
    
    public init(store: StoreOf<AddAttemptsFeature>) {
        self.store = store
    }
}

private extension AddAttemptsView {
    private func makeBodyView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            makeAppBar()
            
            Spacer().frame(height: 20)
            
            ScrollView {
                selectedCragNameView()
                makeSelectedVideoView()
            }
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func makeAppBar() -> some View {
        AppBar {
            Button {
                // Back Button Tapped
            } label: {
                Image.clogUI.back
                    .foregroundStyle(Color.clogUI.white)
            }
        } rightContent: { }
    }
    
    private func makePhotoPickerView() -> some View {
        PhotosPicker(
            selection: .init(
                get: { store.videoSelections },
                set: { send(.videoSelectionChanged($0)) }
            ),
            selectionBehavior: .continuous,
            matching: .videos,
            photoLibrary: .shared()
        ) {
            
        }
        .photosPickerStyle(.inline)
    }
    
    private func selectedCragNameView() -> some View {
        HStack(spacing: 0) {
            Image.clogUI.location
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.clogUI.white)
            
            Text("클로그 암장")
                .font(.h2)
                .foregroundStyle(Color.clogUI.gray10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func makeSelectedVideoView() -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
            ForEach(store.loadedVideos) { video in
                VideoThumbnailView(
                    url: video.url,
                    timeString: video.formattedDuration,
                    size: size
                )
            }
        }
    }
}

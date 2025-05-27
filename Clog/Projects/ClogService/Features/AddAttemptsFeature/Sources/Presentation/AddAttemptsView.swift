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
    @State private var showPhotoPicker: Bool = false // TODO: Reducer로 옮기기
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    public var body: some View {
        makeBodyView()
            .background(Color.clogUI.gray800)
            .onAppear {
                self.showPhotoPicker = true
                send(.onAppear)
            }
            .fullScreenCover(isPresented: $showPhotoPicker) {
                //            .fullScreenCover(isPresented: $store.showPhotoPicker) {
                makePhotoPickerView()
            }
    }
    
    public init(store: StoreOf<AddAttemptsFeature>) {
        self.store = store
    }
}

private extension AddAttemptsView {
    private func makeBodyView() -> some View {
        VStack(spacing: 0) {
            makeAppBar()
            
            ScrollView {
                selectedCragNameView()
                makeSelectedVideoView()
            }
        }
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
    }
    
    private func makeSelectedVideoView() -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
            ForEach(store.loadedVideos) { video in
                VideoThumbnailView(url: video.url, duration: video.duration)
            }
        }
    }
}

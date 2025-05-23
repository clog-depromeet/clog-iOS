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

public struct AddAttemptsView: View {
    @Bindable private var store: StoreOf<AddAttemptsFeature>
    @State private var showPhotoPicker: Bool = false // TODO: Reducer로 옮기기

    
    public var body: some View {
        makeBodyView()
            .background(Color.clogUI.gray800)
            .onAppear {
                self.showPhotoPicker = true
                store.send(.view(.onAppear))
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
                set: { store.send(.view(.videoSelectionChanged($0))) }
            ),
            selectionBehavior: .continuous,
            matching: .videos,
            photoLibrary: .shared()
        ) { }
        .photosPickerStyle(.inline)
    }
}

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
            .background(Color.clogUI.gray900)
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
            .presentDialog(
                $store.scope(
                    state: \.showCancelAttemptAlert,
                    action: \.presentedAlert
                ),
                style: .delete
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
                
                Spacer().frame(height: 20)
                
                makeSelectedVideoView()
                
                Spacer().frame(height: 20)
                
                makeTotalTimeView()
            }
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func makeAppBar() -> some View {
        AppBar {
            Button {
                send(.didTapBackButton)
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
        .preferredColorScheme(.dark)
        .photosPickerStyle(.inline)
    }
    
    private func selectedCragNameView() -> some View {
        let title: String
        let color: Color
        
        if let crag = store.nearByCragState.selectedCrag {
            title = crag.name
            color = Color.clogUI.gray10
        } else {
            title = "암장 정보 미등록"
            color = Color.clogUI.gray400
        }
        
        return HStack(spacing: 4) {
            Image.clogUI.location
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(color)
            
            Text(title)
                .font(.h2)
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
            send(.didTapCragTitleView)
        }
    }
    
    private func makeSelectedVideoView() -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible()), count: 2),
            spacing: 18
        ) {
            ForEach(store.loadedVideos) { video in
                VideoThumbnailView(
                    url: video.url,
                    timeString: video.formattedDuration,
                    size: size
                )
            }
        }
    }
    
    private func makeTotalTimeView() -> some View {
        VStack(spacing: 0) {
            Text("총 운동 시간")
                .font(.h5)
                .foregroundStyle(Color.clogUI.gray400)
            
            Text(store.loadedVideosTotalDurationString)
                .font(.h1)
                .foregroundStyle(Color.clogUI.gray10)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.clogUI.gray800)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

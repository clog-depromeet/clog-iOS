//
//  FolderView.swift
//  FolderFeatureFeature
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import Core
import DesignKit
import ComposableArchitecture

public struct FolderView: ViewProtocol {
    @Bindable var store: StoreOf<FolderFeature>
    let items = Array(1...20)
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private let size = (UIScreen.main.bounds.width / 2) - 20
    
    public init(store: StoreOf<FolderFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            makeBodyView()
                .padding(.vertical, 18)
                .background(Color.clogUI.gray800)
                .onAppear {
                    store.send(.onAppear)
                }
                .bottomSheet(isPresented: $store.showSelectGradeBottomSheet, height: 276) {
                    showSelectGradeBottomSheet()
                        .padding(16)
                }
                .bottomSheet(isPresented: $store.showSelectCragBottomSheet) {
                    showSelectCragBottomSheet()
                        .padding(16)
                }
            
            FloatingActionButton(image: Image.clogUI.gallery) {
                store.send(.moveToAddAttempts)
            }
        }
    }
}

extension FolderView {
    private func makeBodyView() -> some View {
        ZStack {
            switch store.viewState {
            case .loading:
                makeLoadingView()
                
            case .loaded:
                makeContentView()
            }
        }
    }
    
    private func makeLoadingView() -> some View {
        ZStack {
            Color.clogUI.gray800
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: ClogUI.gray500))
                .scaleEffect(2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    
    }
    
    private func makeContentView() -> some View {
        ScrollView {
            if store.filterableAttemptInfo != nil {
                VStack (alignment: .leading) {
                    makeTitleView()
                    
                    ScrollView(.horizontal) {
                        makeChipView()
                    }
                    .scrollIndicators(.hidden)
                    .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
                .frame(height: 24)
            
            if store.attempts.isEmpty {
                VStack {
                    Spacer()
                    makeEmptyView()
                    Spacer()
                }
                .frame(maxWidth: .infinity, minHeight: 500)
            } else {
                makeThumbnailView()
            }
        }
        .padding(.horizontal, 16)
        .scrollIndicators(.hidden)
    }
    
    private func makeEmptyView() -> some View {
        VStack(spacing: 20) {
            ClogUI.videoNone
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundStyle(Color.clogUI.gray500)
            
            Text("아직 기록이 없어요.")
                .font(.h3)
                .foregroundStyle(Color.clogUI.gray500)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func makeTitleView() -> some View {
        HStack(spacing: 7) {
            Text("나의 클라이밍 기록")
                .font(.h3)
                .foregroundStyle(Color.clogUI.white)
            
            Text("\(store.attempts.count)")
                .font(.h3)
                .foregroundStyle(Color.clogUI.gray300)
        }
    }
    
    private func makeChipView() -> some View {
        HStack {
            ForEach(store.chips, id: \.self) { chip in
                
                let isSelectedChip = switch chip {
                case .complete: store.attemptFilter.attemptResult == .complete
                case .fail: store.attemptFilter.attemptResult == .fail
                case .grade: store.attemptFilter.grade != nil
                case .crag: store.attemptFilter.crag != nil
                }
                
                switch chip {
                case .complete:
                    CompleteOrFailChip(
                        challengeResult: .complete,
                        isActive: isSelectedChip
                    ).onTapGesture {
                        store.send(.completeChipTapped)
                    }
                case .fail:
                    CompleteOrFailChip(
                        challengeResult: .fail,
                        isActive: isSelectedChip
                    ).onTapGesture {
                        store.send(.failChipTapped)
                    }
                case .grade:
                    TitleWithImageChip(
                        title: isSelectedChip ? store.attemptFilter.grade?.name ?? "" : "난이도",
                        imageName: isSelectedChip ? "close" : "icon_down",
                        forgroundColor: isSelectedChip ? Color.clogUI.gray800 : Color.clogUI.gray200,
                        backgroundColor: isSelectedChip ? Color.clogUI.primary : Color.clogUI.gray600,
                        tapHandler: {
                            store.send(.gradeChipTapped)
                        }
                    )
                case .crag:
                    TitleWithImageChip(
                        title: isSelectedChip ? store.attemptFilter.crag?.name ?? "" : "암장",
                        imageName: isSelectedChip ? "close" : "icon_down",
                        forgroundColor: isSelectedChip ? Color.clogUI.gray800 : Color.clogUI.gray200,
                        backgroundColor: isSelectedChip ? Color.clogUI.primary : Color.clogUI.gray600,
                        tapHandler: {
                            store.send(.cragChipTapped)
                        }
                    )
                }
            }
        }
    }
    
    func makeThumbnailView() -> some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(store.attempts, id: \.self) { attempt in
                ThumbnailView(
                    imageURLString: attempt.thumbnailUrl,
                    thumbnailType: .default(
                        cragName: attempt.crag?.name ?? "",
                        date: attempt.date
                    ),
                    challengeResult: attempt.result == .complete ? .complete : .fail,
                    levelName: attempt.grade?.name,
                    levelColor: Color(hex: attempt.grade?.hexCode ?? "0x00000"),
                    time: attempt.recordedTime,
                    width: size,
                    height: size
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .onTapGesture {
                    store.send(.moveToAttempt(attempt.id))
                }
            }
        }
    }
    
    private func showSelectGradeBottomSheet() -> some View {
        let rows: [GridItem] = [.init(.adaptive(minimum: 60), spacing: 6)]
        return VStack(alignment: .leading, spacing: 16) {
            Text("난이도")
                .font(.h3)
                .foregroundStyle(Color.clogUI.white)
            
            Rectangle()
                .fill(Color.clogUI.gray600)
                .frame(height: 1)
            
            LazyVGrid(columns: rows) {
                ForEach(store.filterableAttemptInfo?.grades ?? [], id: \.self) { grade in
                    LevelChip(
                        name: grade.name,
                        color: Color(hex: grade.hexCode)
                    )
                    .onTapGesture {
                        store.send(.didSelectGrade(grade))
                    }
                }
            }
        }
    }
    
    private func showSelectCragBottomSheet() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("암장명")
                .font(.h3)
                .foregroundStyle(Color.clogUI.white)
            
            ClLogTextInput(
                placeHolder: "암장을 입력해주세요",
                text: $store.searchCragName,
                isFocused: .constant(true)
            )
            
            ForEach(store.filterableAttemptInfo?.crags ?? [].filter { crag in
                if store.searchCragName.isEmpty {
                    return true
                }
                
                return crag.name.matchesPattern(store.searchCragName)
            }, id: \.self) { crag in
                TwoLineRow(
                    title: crag.name,
                    subtitle: crag.address
                )
                .onTapGesture {
                    store.send(.didSelectCrag(crag))
                }
            }
        }
    }
}

#Preview {
    FolderView(
        store: .init(
            initialState: FolderFeature.State(),
            reducer: {
                FolderFeature()
            }
        )
    )
}

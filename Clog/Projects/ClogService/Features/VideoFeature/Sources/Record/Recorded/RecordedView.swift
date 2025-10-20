//
//  RecordedView.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

// Apple Module
import SwiftUI

// 내부 Module
import Shared
import DesignKit
import Core
import VideoFeatureInterface

// 외부 Module
import ComposableArchitecture

public struct RecordedView: View {
    @Dependency(\.videoDataManager) private var videoDataManager
    
    private weak var on: UIViewController?
    
    @Bindable private var store: StoreOf<RecordedFeature>
    @State private var isEditTooltipOn: Bool = false
    
    public init(
        on: UIViewController?,
        store: StoreOf<RecordedFeature>
    ) {
        self.on = on
        self.store = store
    }
    
    public var body: some View {
        bodyView
            .onAppear {
                if videoDataManager.getIsInitializedEditTooltipState() == false {
                    
                    self.isEditTooltipOn = true
                    videoDataManager.setIsEditTooltipOn(true)
                    videoDataManager.setIsInitializedEditTooltipState(true)
                } else {
                    self.isEditTooltipOn = videoDataManager.getIsEditTooltipOn()
                }
                
                store.send(.onAppear)
            }
            .presentDialog($store.scope(state: \.alert, action: \.alert), style: .default)
            .showCragBottomSheet(
                isPresented: .init(get: {
                    store.showSelectCragBottomSheet
                }, set: { newValue in
                    store.send(.cragBottomSheetAction(newValue))
                }),
                didTapSaveButton: { designCrag in
                    store.send(.cragSaveButtonTapped(designCrag))
                }, didTapSkipButton: {
                    store.send(.cragNameSkipButtonTapped)
                }, didNearEnd: {
                    store.send(.loadMoreCrags)
                }, didChangeSearchText: { searchText in
                    store.send(.cragName(keyWord: searchText))
                }, matchesPattern: { crag, searchText in
                    crag.name.matchesPattern(searchText)
                }, crags: $store.designCrags
            )
            .presentDialog($store.scope(state: \.cragAlert, action: \.cragAlert))
            .showGradeBottomSheet(
                isPresented: $store.showSelectCragDifficultyBottomSheet,
                cragName: store.selectedDesignCrag?.name ?? "",
                grades: store.grades.map {
                    DesignGrade(id: $0.id, name: $0.name, color: .init(hex: $0.hexCode))
                },
                didTapSaveButton: { designGrade in
                    store.send(.gradeSaveButtonTapped(designGrade))
                }, didTapCragTitleButton: {
                    store.send(.gradeTapCragTitleButton)
                })
            .onTapGesture {
                self.isEditTooltipOn = false
                self.videoDataManager.setIsEditTooltipOn(false)
            }
    }
    
    @ViewBuilder
    private var bodyView: some View {
        ZStack {
            #if targetEnvironment(simulator)
            Color.gray
                .ignoresSafeArea()
            #else
            RecordedPlayPreview(viewModel: store.viewModel)
                .ignoresSafeArea()
            #endif

            VStack(spacing: .zero, content: {
                headerActionsView
                Spacer()
                footerActionsView
            })

            CLLogLoadingView(isLoading: $store.isLoading)
        }
    }
    
    @ViewBuilder
    private var headerActionsView: some View {
        ZStack {
            HStack {
                Button(action: {
                    store.send(.closeButtonTapped)
                }) {
                    Image.clogUI.icn_close
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.clogUI.gray500.opacity(0.5))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text(store.duration)
                    .font(.h5)
                    .foregroundColor(.clogUI.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.clogUI.gray500.opacity(0.5))
                    .clipShape(Capsule())
                
                Spacer()
                
                // 오른쪽 버튼 (편집)
                Button(action: {
                    store.send(.editButtonTapped)
                }) {
                    Text("편집")
                        .font(.h5)
                        .foregroundColor(.clogUI.white)
                        .frame(width: 40, height: 40)
                        .background(Color.clogUI.gray500.opacity(0.5))
                        .clipShape(Circle())
                }
                .tooltip(text: "편집 버튼으로 영상을\n자유롭게 수정할 수 있어요!", position: .bottomTrailing(offset: -21), verticalOffset: 12, isVisible: isEditTooltipOn)
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 64)
    }
    
    @ViewBuilder
    private var footerActionsView: some View {
        VStack(spacing: .zero) {
            PlayerProgressBar(duration: Double(store.totalDuration / 1000), progress: store.progress, stampTimeList: store.stampTimeList) { stampTime in
                store.send(.seek(stampTime))
            }
            
            Group {
                HStack(spacing: 7) {
                    Button(action: {
                        store.send(.failureTapped)
                    }) {
                        Text("실패로 저장")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.clogUI.gray600)
                            .foregroundColor(.clogUI.white)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        store.send(.successTapped)
                    }) {
                        Text("완등으로 저장")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.clogUI.white)
                            .foregroundColor(.clogUI.gray800)
                            .cornerRadius(12)
                    }
                }
                .font(.b1)
                .padding(.horizontal, 16)
            }
            .frame(height: 94)
            .background(
                Color.clogUI.gray900
                    .edgesIgnoringSafeArea(.bottom)
            )
        }
    }
}

//
//  VideoView.swift
//  VideoFeature
//
//  Created by lin.saeng on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

// Apple Module
import UIKit
import SwiftUI

// 내부 Module
import DesignKit
import VideoFeatureInterface

// 외부 Module
import ComposableArchitecture

public struct VideoView: View {
    @Dependency(\.videoDataManager) private var videoDataManager
    
    @Bindable private var store: StoreOf<VideoFeature>
    @State private var isRecordTooltipOn: Bool = false
    
    public init(
        store: StoreOf<VideoFeature>
    ) {
        self.store = store
    }
    
    public var body: some View {
        bodyView
            .debugFrameSize()
            .onAppear {
                if videoDataManager.getIsInitializedRecordTooltipState() == false {
                    
                    self.isRecordTooltipOn = true
                    videoDataManager.setIsRecordTooltipOn(true)
                    videoDataManager.setIsInitializedRecordTooltipState(true)
                } else {
                    self.isRecordTooltipOn = videoDataManager.getIsRecordTooltipOn()
                }
                store.send(.onAppear)
            }
            .overlay(
                Group {
                    if store.state.showSelectGradeView {
                        selectGradeView
                    }
                }
            )
            .bottomSheet(isPresented: $store.showProblemCheckCompleteBottomSheet, height: 267) {
                IfLetStore(
                    store.scope(
                        state: \.problemCheckCompleteBottomSheetState,
                        action: \.problemCheckCompleteBottomSheetAction
                    ),
                    then: ProblemCheckCompleteBottomSheet.init
                )
            }
            .bottomSheet(isPresented: $store.showFolderBottomSheet, height: 355) {
                IfLetStore(
                    store.scope(
                        state: \.problemCheckState,
                        action: \.problemCheckAction
                    ),
                    then: ProblemCheckBottomSheet.init
                )
            }
            .presentDialog($store.scope(state: \.alert, action: \.alert), style: .default)
    }
}

private extension VideoView {
    @ViewBuilder
    var bodyView: some View {
        switch store.viewState {
        case .normal:
            ZStack {}
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clogUI.gray800)
            
        case .noneVideoPermission:
            ZStack {}
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clogUI.gray800)
            
        case .video:
            camerView
                .onAppear {
                    store.send(.onStartSession)
                }
                .onTapGesture {
                    isRecordTooltipOn = false
                    videoDataManager.setIsRecordTooltipOn(false)
                }
        }
    }
    
    private var selectGradeView: some View {
        ZStack {
            ClogUI.dim.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    store.send(.backgroundViewTapped)
                }
            
            VStack(spacing: 18) {
                Text("다음 문제 난이도를 선택해주세요")
                    .font(.h3)
                    .foregroundStyle(ClogUI.gray10)
                    .frame(maxWidth: .infinity)
                
                GridGradeView(
                    grades: store.grades.map {
                        DesignGrade(id: $0.id, name: $0.name, color: .init(hex: $0.hexCode))
                    },
                    selectedGrade: $store.selectedGrade
                )
                
                CheckBoxButton(
                    title: "난이도 미등록",
                    isActive: $store.doNotSaveGrade
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .onChange(of: store.selectedGrade) { _, newValue in
                store.send(.selectNextGrade(grade: newValue))
            }
            .onChange(of: store.doNotSaveGrade) { _, newValue in
                store.send(.selectNextGrade(grade: nil))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(ClogUI.gray900)
            .cornerRadius(12)
            .shadow(radius: 10)
            .padding(.bottom, 150)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.horizontal, 16)
        }
    }
}

private extension VideoView {
    
    var camerView: some View {
        ZStack {
            #if !targetEnvironment(simulator)
            VideoPreview(camera: store.cameraModel)
                .ignoresSafeArea()
            #else
            Color.clogUI.gray100
                .ignoresSafeArea()
            #endif
            
            VStack(spacing: .zero) {
                
                if store.count > 0 {
                    HStack(alignment: .center) {
                        
                        if let grade = store.grade {
                            LevelChip(name: grade.name, color: .init(hex: grade.hexCode))
                        }
                        
                        Spacer()
                        
                        Button {
                            store.send(.endedStoryTapped)
                        } label: {
                            Text("종료")
                                .font(.h5)
                                .foregroundColor(.clogUI.white)
                                .frame(width: 40, height: 40)
                                .background(Color.clogUI.gray500.opacity(0.5))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
                
                Color.clear
                    .frame(height: 64)
                
                HStack(spacing: .zero) {
                    
                    // TODO: 카메라 기능 옵션
                    VStack {
                        Button {
                            
                        } label: {
                            Image.clogUI.flashOff
                                .renderingMode(.template)
                                .foregroundColor(.clogUI.white)
                                .frame(width: 40, height: 40)
                                .background(Color.clogUI.gray500.opacity(0.5))
                                .clipShape(Capsule())
                        }
                        
                        Button {
                            
                        } label: {
                            Text("9:16")
                                .font(.h5)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.clogUI.white)
                                .background(Color.clogUI.gray500.opacity(0.5))
                                .clipShape(Capsule())
                        }
                        
                        Button {
                            
                        } label: {
                            Text("1x")
                                .font(.h5)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.clogUI.white)
                                .background(Color.clogUI.gray500.opacity(0.5))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.top, 42)
                    .padding(.leading, 16)
                    .hidden()
                    
                    Spacer()
                }
                .hidden()
                
                Spacer()
                
                HStack(alignment: .center) {
                    if store.count > 0 {
                        FolderButton(count: $store.count) {
                            store.send(.folderTapped)
                        }
                    }
                    
                    Spacer()
                    
                    RecodingButton(isRecoding: .init(
                        get: { false },
                        set: { newValue in }
                    ), isRecordTooltipOn: $isRecordTooltipOn, onTapped: {
                        self.isRecordTooltipOn = false
                        store.send(.onStartRecord)
                    })
                    
                    Spacer()
                    if store.count > 0 {
                        NextProblemButton {
                            store.send(.nextProblemTapped)
                        }
                    }
                }
                .padding(.horizontal, 42)
                .padding(.bottom, 40)
            }
        }
    }
}

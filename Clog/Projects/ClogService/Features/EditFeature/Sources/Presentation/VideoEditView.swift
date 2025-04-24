//
//  VideoEditView.swift
//  EditFeature
//
//  Created by seunghwan Lee on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import AVKit
import DesignKit
import Combine

public struct VideoEditView: View {
    private let tooltipManager: EditFeatureTooltipManager
    @Bindable var store: StoreOf<VideoEditFeature>
    
    @State private var isDraggingPlayhead = false
    @State private var isInitialized = false
    @State private var isStampTooltipOn = false
    @State private var isDragEditTooltipOn = false
    @State private var timeObserverCancellable: AnyCancellable?
    
    @Environment(\.presentationMode) var presentationMode
    
    public init(store: StoreOf<VideoEditFeature>) {
        self.store = store
        self.tooltipManager = EditFeatureTooltipManager()
    }
    
    private var closeButton: some View {
        Button {
            store.send(.didTapEditCancel)
        } label: {
            Image.clogUI.close
        }
    }
    
    private var completeButton: some View {
        Button {
            store.send(.didTapEditCompelete)
        } label: {
            Text("완료")
                .font(.b2)
                .frame(width: 40, height: 40)
        }
    }
    
    private var currentTime: some View {
        Text(store.formattedCurrentTime)
            .font(.h5)
    }
    
    private var videoPlayer: some View {
        VStack {
            ZStack {
                VideoPlayer(player: Current.player)
                    .aspectRatio(9/16, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if !store.isVideoReady {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
        }
    }
    
    private var playPauseButton: some View {
        Button {
            store.send(.didTapPlayPause)
        } label: {
            if store.isPlaying {
                Image.clogUI.stopSmall
            } else {
                Image.clogUI.playSmall
            }
        }
    }
    
    private var undoStampButton: some View {
        Button {
            store.send(.didTapUndoStamp)
        } label: {
            if store.stampList.isEmpty {
                Image.clogUI.undoDisable
            } else {
                Image.clogUI.undoEnable
            }
        }
    }
    
    private var redoStampButton: some View {
        Button {
            store.send(.didTapRedoStamp)
        } label: {
            if store.popedStampList.isEmpty {
                Image.clogUI.redoDisable
            } else {
                Image.clogUI.redoEnable
            }
        }
    }
    
    private var stampArea: some View {
        Color.clear
            .frame(height: 11)
            .overlay {
                ForEach(store.stampList) { stamp in
                    Image.clogUI.stampSmall
                        .foregroundStyle(stamp.isValid ? Color.clogUI.primary : Color.clogUI.gray500)
                        .position(x: stamp.xPos + 2.5, y: 5.5)
                }
            }
            .padding(.horizontal, 21)
    }
    
    private var playHead: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.white)
            .frame(width: 5, height: 75)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                closeButton
                Spacer()
                completeButton
            }
            .overlay {
                currentTime
            }
            .foregroundStyle(Color.clogUI.white)
            .frame(height: 60)
            .padding(.horizontal, 16)
            
            videoPlayer
                .disabled(true)
            
            HStack {
                Spacer()
                
                StampButton {
                    store.send(.didTapStamp)
                }
                .tooltip(text: "스탬프 버튼을 눌러\n중요 부분을 기록할 수 있어요!", position: .topTrailing(offset: -21), verticalOffset: 16, isVisible: isStampTooltipOn)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            HStack(spacing: 8) {
                playPauseButton
                
                Spacer()
                
                undoStampButton
                redoStampButton
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 1)
            
            VStack(spacing: 6) {
                stampArea
                
                ZStack {
                    GeometryReader { proxy in
                        if let asset = Current.asset {
                            ThumbnailsView(asset: asset, duration: store.duration, frameSize: proxy.size)
                        }
                        
                        DragEditView(
                            leftPosition: Binding(
                                get: { store.trimStartPosition },
                                set: { store.send(.updateTrimStartPosition(position: $0)) }
                            ),
                            rightPosition: Binding(
                                get: { store.trimEndPosition },
                                set: { store.send(.updateTrimEndPosition(position: $0)) }
                            ),
                            frameSize: proxy.size
                        )
                        
                        playHead
                            .offset(x: store.playheadPosition, y: -2.5)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        if !isDraggingPlayhead {
                                            if store.isPlaying {
                                                store.send(.didTapPlayPause)
                                            }
                                            isDraggingPlayhead = true
                                        }
                                        
                                        let newPosition = max(store.trimStartPosition,
                                                              min(store.trimEndPosition,
                                                                  value.location.x))
                                        
                                        store.send(.updatePlayHead(newPosition: newPosition))
                                    }
                                    .onEnded { _ in
                                        isDraggingPlayhead = false
                                    }
                            )
                    }
                    .padding(.horizontal, 21)
                }
                .frame(height: 70)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
            .tooltip(text: "드래그로 영상을 자를 수 있어요!", position: .topCenter, verticalOffset: 1, isVisible: isDragEditTooltipOn)
        }
        .presentDialog($store.scope(state: \.alert, action: \.alert), style: .default)
        .background(Color.clogUI.gray900)
        .onAppear {
            tooltipManager.initTooltipState()
            self.isStampTooltipOn = tooltipManager.isStampTooltipOn
            self.isDragEditTooltipOn = tooltipManager.isDragEditTooltipOn
            
            if !isInitialized {
                store.send(.onAppear)
                
                timeObserverCancellable = Current.timeSubject
                    .receive(on: RunLoop.main)
                    .sink { currentTime in
                        store.send(.playerResponse(.timeUpdated(currentTime: currentTime)))
                    }
                
                isInitialized = true
            }
        }
        .onDisappear {
            timeObserverCancellable?.cancel()
        }
        .onReceive(store.publisher.shouldDismiss) { shouldDismiss in
            if shouldDismiss {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .onTapGesture {
            if isStampTooltipOn {
                isStampTooltipOn = false
                isDragEditTooltipOn = true
                tooltipManager.setStampTooltipOff()
            } else if isDragEditTooltipOn {
                isDragEditTooltipOn = false
                tooltipManager.setDragEditTooltipOff()
            }
        }
    }
}

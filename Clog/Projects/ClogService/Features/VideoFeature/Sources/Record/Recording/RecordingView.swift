//
//  RecordingView.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

// Apple Module
import UIKit
import SwiftUI

// 내부 Module
import DesignKit
import Shared

// 외부 Moduel
import ComposableArchitecture

public struct RecordingView: View {
    
    private weak var on: UIViewController? = nil
    private let store: StoreOf<RecordingFeature>
    
    public init(
        on: UIViewController? = nil,
        store: StoreOf<RecordingFeature>
    ) {
        self.on = on
        self.store = store
    }
    
    public var body: some View {
        bodyView
            .onAppear {
                store.send(.onAppear)
            }
    }
    
    @ViewBuilder
    private var bodyView: some View {
        
#if targetEnvironment(simulator)
        Color.gray
            .ignoresSafeArea()
#else
        RecordingPlyPreview(viewModel: store.viewModel)
            .ignoresSafeArea()
#endif
        
        VStack(spacing: .zero) {
            ZStack {
                HStack {
                    if let grade = store.grade {
                        LevelChip(name: grade.name, color: .init(hex: grade.hexCode))
                    }
                    Spacer()
                }
                
                Text(store.elapsedTime.formatTimeInterval())
                    .font(.h5)
                    .foregroundColor(.clogUI.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.clogUI.gray500.opacity(0.5))
                    .clipShape(Capsule())
            }
            .frame(height: 64)
            .padding(.horizontal, 16)
            
            HStack(spacing: .zero) {
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
            
            Spacer()
            
            RecodingButton(isRecoding: .init(
                get: { true },
                set: { newValue in }
            ), isRecordTooltipOn: .constant(false), onTapped: {
                store.send(.onStopRecording)
            }).padding(.bottom, 40)
        }
    }
}

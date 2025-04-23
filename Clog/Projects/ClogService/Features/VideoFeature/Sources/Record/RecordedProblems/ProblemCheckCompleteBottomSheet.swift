//
//  ProblemCheckCompleteBottomSheet.swift
//  VideoFeature
//
//  Created by seunghwan Lee on 3/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import DesignKit

struct ProblemCheckCompleteBottomSheet: View {
    private let store: StoreOf<ProblemCheckCompleteBottomSheetFeature>
    
    init(store: StoreOf<ProblemCheckCompleteBottomSheetFeature>) {
        self.store = store
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("총 운동 시간")
                    .frame(height: 21)
                    .font(.h5)
                    .foregroundStyle(Color.clogUI.gray400)
                Text(store.story.totalDurationMs.msToTimeString)
                    .frame(height: 36)
                    .font(.h1)
                    .foregroundStyle(Color.clogUI.gray10)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                Color.clogUI.gray900
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            
            GeneralButton("종료하기") {
                store.send(.finishTapped)
            }
            .style(.white)
            .padding(.horizontal, 16)
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    Color.white
        .bottomSheet(isPresented: .constant(true), height: 355) {
            ProblemCheckCompleteBottomSheet(
                store: .init(initialState: ProblemCheckCompleteBottomSheetFeature.State(storyId: 0), reducer: {
                    ProblemCheckCompleteBottomSheetFeature()
                })
            )
        }
}

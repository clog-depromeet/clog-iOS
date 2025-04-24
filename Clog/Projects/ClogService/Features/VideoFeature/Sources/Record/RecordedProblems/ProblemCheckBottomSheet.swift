//
//  ProblemCheckBottomSheet.swift
//  VideoFeature
//
//  Created by seunghwan Lee on 3/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import DesignKit
import ComposableArchitecture
import StoryDomain
import Shared

public struct ProblemView: View {
    
    @State private var isOpened: Bool = false
    let problem: StoryProblem
    let index: Int
    let deleteTapped: (StoryAttempt) -> Void
    
    init(
        problem: StoryProblem,
        index: Int,
        deleteTapped: @escaping (StoryAttempt) -> Void
    ) {
        self.problem = problem
        self.index = index
        self.deleteTapped = deleteTapped
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.init(hex: problem.colorHex ?? "#41444D"))
                    .frame(width: 16, height: 16)
                
                Text("문제 \(index)")
                    .font(.h3)
                    .foregroundStyle(Color.clogUI.white)
                
                Button {
                    isOpened.toggle()
                } label: {
                    isOpened ? Image.clogUI.dropdownUp : Image.clogUI.dropdownDown
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Text("실패 \(problem.failCount)")
                    Color.clogUI.gray700
                        .frame(width: 1, height: 14)
                    Text("완등 \(problem.successCount)")
                }
                .font(.h5)
                .foregroundStyle(Color.clogUI.gray200)
            }
            .padding(.horizontal, 16)
            
            if isOpened {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 12) {
                        ForEach(problem.attempts, id: \.self) { attempt in
                            ReportVideoImageView(
                                imageName: attempt.video.thumbnailUrl ?? "",
                                challengeResult: attempt.status == .success ? .complete : .fail,
                                deleteButtonHandler: {
                                    deleteTapped(attempt)
                                }
                            )
                        }
                    }
                    .frame(height: 84)
                    .padding(.top, 4)
                    .padding(.horizontal, 16)
                }
                .scrollIndicators(.hidden)
                .padding(.top, 8)
            }
        }
    }
}

public struct ProblemCheckBottomSheet: View {
    private let store: StoreOf<ProblemCheckFeature>
    
    public init(store: StoreOf<ProblemCheckFeature>) {
        self.store = store
    }
    
    var divider: some View {
        Color.clogUI.gray700
            .frame(height: 1)
            .padding(.vertical, 20)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(store.problems.indices, id: \.self) { idx in
                ProblemView(
                    problem: store.problems[idx],
                    index: idx + 1
                ) { attempt in
                    store.send(.deleteProblemTapped(attempt))
                }
                if store.problems.count != idx + 1 {
                    divider
                }
            }
            Spacer()
        }
        .onAppear {
            store.send(.onAppear)
        }
        .overlay {
            if store.isLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    Color.white
        .bottomSheet(isPresented: .constant(true), height: 355) {
            ProblemCheckBottomSheet(
                store: .init(
                    initialState: ProblemCheckFeature.State(storyId: 0),
                    reducer: {
                        ProblemCheckFeature()
                    }
                )
            )
        }
}

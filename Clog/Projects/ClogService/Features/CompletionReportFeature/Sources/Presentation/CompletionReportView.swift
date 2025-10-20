//
//  CompletionReportView.swift
//  CompletionReportFeature
//
//  Created by Junyoung on 3/31/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import DesignKit

public struct CompletionReportView: View {
    @Bindable private var store: StoreOf<CompletionReportFeature>
    
    @State private var renderedImage = Image(systemName: "photo")
    @Environment(\.displayScale) var displayScale
    @State private var loadedImage: Image?
    
    public init(store: StoreOf<CompletionReportFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            makeBody()
                .background(Color.clogUI.gray900)
                .onAppear {
                    store.send(.onAppear)
                }
            
            if store.sharedShow {
                InstagramSharerView(
                    filePath: store.sharedURL,
                    uti: "\(Date.now)",
                    isPresented: $store.sharedShow
                )
            }
        }
    }
}

extension CompletionReportView {
    private func makeBody() -> some View {
        VStack(spacing: 0) {
            makeAppBar()
            ScrollView(showsIndicators: false) {
                makeContent
            }
            Spacer()
            makeBottomBotton()
        }
    }
    
    private func makeAppBar() -> some View {
        AppBar {
            Button {
                store.send(.finish)
            } label: {
                Image.clogUI.back
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.clogUI.white)
            }
        } rightContent: {
            Button {
                let image = makeContent.snapshot()
                store.send(.shareButtonTapped(image))
            } label: {
                Image.clogUI.share
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.clogUI.white)
            }
        }
        .background(Color.clogUI.gray900)
    }
    
    // Snapshot 찍어서 저장할 View
    var makeContent: some View {
        VStack {
            makeCragName()
            Spacer(minLength: 20)
            makeThumbnail()
            Spacer(minLength: 20)
            totalExerciseTime()
            Spacer(minLength: 12)
            makeCompletionStatsView()
            Spacer(minLength: 12)
            makeProblemView()
                .padding(.bottom, 16)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.clogUI.gray900)
    }
    
    private func makeCragName() -> some View {
        HStack(spacing: 4) {
            Image.clogUI.location
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.clogUI.gray10)
            
            Text("\(store.summary.cragName ?? "암장 미등록")")
                .font(.h2)
                .foregroundStyle(Color.clogUI.white)
            
            Spacer()
        }
    }
    
    private func makeThumbnail() -> some View {
        ZStack(alignment: .bottom) {
            if let loadedImage {
                loadedImage
                    .resizable()
                    .scaledToFill()
                    .frame(height: 343)
                    .frame(maxWidth: UIScreen.main.bounds.width - 32)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                AsyncImage(url: URL(string: store.summary.thumbnailUrl ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 343)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .onAppear {
                                loadedImage = image
                            }
                    case .failure:
                        Image.clogUI.alert
                            .resizable()
                            .frame(height: 343)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            HStack(spacing: 0) {
                Spacer()
                Image.clogUI.clogLogo
                    .resizable()
                    .frame(width: 40, height: 24)
                    .foregroundStyle(Color.clogUI.primary)
                
                Spacer(minLength: 24)
                
                Text(
                    store.summary.date.toDate(format: "yyyy.MM.dd e")
                        .formattedString(
                            "yy.MM.dd E",
                            locale: Locale(identifier: "en_US")
                        ).uppercased()
                )
                .font(.h4)
                .foregroundStyle(Color.clogUI.primary)
                
                DividerView(.vertical, color: Color.clogUI.primary)
                    .padding(.vertical, 5)
                
                Text(store.summary.totalDurationMs.msToTimeString)
                    .font(.h4)
                    .foregroundStyle(Color.clogUI.primary)
                Spacer()
            }
            .padding(.horizontal, 26)
            .padding(.vertical, 10)
            .background(Color.clogUI.gray900.opacity(0.6))
            .frame(height: 44)
            .clipShape(RoundedRectangle(cornerRadius: 50))
            .padding(.bottom, 18)
            .padding(.horizontal, 21)
        }
    }
    
    private func totalExerciseTime() -> some View {
        VStack(alignment: .center) {
            Text("총 운동 시간")
                .font(.h5)
                .foregroundStyle(Color.clogUI.gray400)
            
            Text(store.summary.totalDurationMs.msToTimeString)
                .font(.h1)
                .foregroundStyle(Color.clogUI.gray10)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.clogUI.gray800)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func makeCompletionStatsView() -> some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Text("시도 횟수")
                    .font(.h5)
                    .foregroundStyle(Color.clogUI.gray400)
                Text("\(store.summary.totalAttemptsCount)")
                    .font(.h1)
                    .foregroundStyle(Color.clogUI.gray10)
            }
            .frame(maxWidth: .infinity)
            
            DividerView(.vertical, color: Color.clogUI.gray600)
            
            VStack(alignment: .center) {
                Text("완등 횟수")
                    .font(.h5)
                    .foregroundStyle(Color.clogUI.gray400)
                Text("\(store.summary.totalSuccessCount)")
                    .font(.h1)
                    .foregroundStyle(Color.clogUI.gray10)
            }
            .frame(maxWidth: .infinity)
            
            DividerView(.vertical, color: Color.clogUI.gray600)
            
            VStack(alignment: .center) {
                Text("실패 횟수")
                    .font(.h5)
                    .foregroundStyle(Color.clogUI.gray400)
                Text("\(store.summary.totalFailCount)")
                    .font(.h1)
                    .foregroundStyle(Color.clogUI.gray10)
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .padding(16)
        .background(Color.clogUI.gray800)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func makeBottomBotton() -> some View {
        GeneralButton("확인") {
            store.send(.finish)
        }
        .style(.white)
    }
    
    private func makeProblemView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 0) {
                Text("푼 문제")
                    .font(.h5)
                    .foregroundStyle(Color.clogUI.gray400)
                
                Spacer()
            }
            
            
            ForEach(store.summary.problems.indices, id: \.self) { index in
                VStack(spacing: 4) {
                    HStack(spacing: 12) {
                        Text("문제 \(index + 1)")
                            .font(.h4)
                            .foregroundStyle(Color.clogUI.gray10)
                        HStack(spacing: 4) {
                            ForEach(0..<store.summary.problems[index].attemptCount, id: \.self) { _ in
                                Circle()
                                    .fill(Color(hex: store.summary.problems[index].displayColorHex))
                                    .frame(width: 24, height: 24)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.clogUI.gray800)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

extension CompletionReportView {
    @MainActor func render() {
        let renderer = ImageRenderer(
            content: makeContent
        )
        
        renderer.scale = displayScale
        
        if let uiImage = renderer.uiImage {
            renderedImage = Image(uiImage: uiImage)
        }
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

#Preview {
    CompletionReportView(
        store: .init(
            initialState: CompletionReportFeature.State(storyId: 0),
            reducer: {
                CompletionReportFeature()
            }
        )
    )
}



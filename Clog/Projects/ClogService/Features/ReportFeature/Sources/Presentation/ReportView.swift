//
//  ReportView.swift
//  ReportFeature
//
//  Created by Junyoung on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import DesignKit
import ReportDomain

public struct ReportView: View {
    private let store: StoreOf<ReportFeature>
    
    public init(store: StoreOf<ReportFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBody()
            .background(Color.clogUI.gray800)
            .onAppear {
                store.send(.onAppear)
            }

    }
}

extension ReportView {
    private func makeBody() -> some View {
        VStack(spacing: 0) {
            makeAppBar()
            Spacer(minLength: 10)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    makeInformation()
                        .padding(.horizontal, 4)
                    
                    makeWorkoutDurationView()
                    makeCompletionStatsView()
                    if let mostAttemptedProblem = store.report.mostAttemptedProblem {
                        makeChallengeView(mostAttemptedProblem)
                    }
                    if let mostVisitCrag = store.report.mostVisitedCrag {
                        makeFavoriteCragView(mostVisitCrag)
                    }
//                    makeSaveAndSharedButton()
                    informationText()
                        .padding(.bottom, 40)
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private func makeAppBar() -> some View {
        VStack(spacing: 0) {
            AppBar {
                Text("나의 클라이밍 리포트")
                    .font(.h3)
                    .foregroundStyle(Color.clogUI.gray10)
            } rightContent: {
                Button {
                    store.send(.settingTapped)
                } label: {
                    Image.clogUI.setting
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.clogUI.white)
                }
            }
        }
    }
    
    private func makeInformation() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("\(store.report.userName)님,")
                    .font(.h1)
                    .foregroundStyle(Color.clogUI.primary)
                Spacer(minLength: 4)
                Text("최근 3개월동안 \(store.report.recentAttemptCount)일 클라이밍했어요")
                    .font(.h5)
                    .foregroundStyle(Color.clogUI.primary)
                Text("얼마나 열심히 도전했는지 확인해볼까요?")
                    .font(.h5)
                    .foregroundStyle(Color.clogUI.gray400)
            }
            Spacer()
        }
    }
    
    private func makeWorkoutDurationView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("총 운동 시간")
                    .font(.h5)
                    .foregroundStyle(Color.clogUI.gray400)
                Text("\(store.report.totalExerciseTime.totalExerciseTimeMs.msToTimeString)")
                    .font(.h1)
                    .foregroundStyle(Color.clogUI.white)
            }
            .padding(24)
            
            Spacer()
            
            
            Image.clogUI.reportExercise
                .resizable()
                .frame(width: 164)
            
        }
        .background(Color.clogUI.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func makeCompletionStatsView() -> some View {
        HStack {
            VStack(alignment: .center) {
                Image.clogUI.reportProblem
                    .resizable()
                    .frame(width: 64, height: 50)
                Spacer()
                Text("푼 문제")
                    .font(.h5)
                    .foregroundStyle(Color.clogUI.gray400)
                Text("\(store.report.totalAttemptCount.successAttemptCount)")
                    .font(.h1)
                    .foregroundStyle(Color.clogUI.gray10)
            }
            .frame(maxWidth: .infinity)
            
            DividerView(.vertical, color: Color.clogUI.gray600)
                .frame(height: 80)
            
            VStack(alignment: .center) {
                Image.clogUI.reportAttempt
                    .resizable()
                    .frame(width: 64, height: 50)
                Spacer()
                Text("시도 횟수")
                    .font(.h5)
                    .foregroundStyle(Color.clogUI.gray400)
                Text("\(store.report.totalAttemptCount.totalAttemptCount)")
                    .font(.h1)
                    .foregroundStyle(Color.clogUI.gray10)
            }
            .frame(maxWidth: .infinity)
            
            DividerView(.vertical, color: Color.clogUI.gray600)
                .frame(height: 80)
            
            VStack(alignment: .center) {
                Image.clogUI.reportPercent
                    .resizable()
                    .frame(width: 64, height: 50)
                Spacer()
                Text("완등률")
                    .font(.h5)
                    .foregroundStyle(Color.clogUI.gray400)
                Text("\(store.report.totalAttemptCount.completionRate)%")
                    .font(.h1)
                    .foregroundStyle(Color.clogUI.gray10)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .background(Color.clogUI.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func makeChallengeView(_ mostAttemptedProblem: MostAttemptedProblem) -> some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("\(store.report.userName)님의 가장 뿌듯했던 도전")
                    .font(.h5)
                    .foregroundStyle(Color.clogUI.gray400)
                
                Spacer(minLength: 4)
                if let mostAttemptedProblemCrag = mostAttemptedProblem.mostAttemptedProblemCrag {
                    Text("\(mostAttemptedProblemCrag)에서")
                        .font(.h3)
                        .foregroundStyle(Color.clogUI.gray10)
                } else {
                    Text("최근에 도전한 암장이 없습니다.")
                        .font(.h3)
                        .foregroundStyle(Color.clogUI.gray10)
                }
                HStack(spacing: 0) {
                    if let mostAttemptedProblemGrade = mostAttemptedProblem.mostAttemptedProblemGrade {
                        Text("\(mostAttemptedProblemGrade) ")
                            .font(.h3)
                            .foregroundStyle(Color.clogUI.primary)
                        Text("문제를 ")
                            .font(.h3)
                            .foregroundStyle(Color.clogUI.gray10)
                        Text("\(mostAttemptedProblem.mostAttemptedProblemAttemptCount)번 ")
                            .font(.h3)
                            .foregroundStyle(Color.clogUI.primary)
                        Text("도전해 완등했네요!")
                            .font(.h3)
                            .foregroundStyle(Color.clogUI.gray10)
                    }
                    Spacer()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 28)
            
            Spacer(minLength: 16)
            
            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(mostAttemptedProblem.attemptVideos, id: \.self) { video in
                            ThumbnailView(
                                imageURLString: video.thumbnailUrl,
                                thumbnailType: .calendar,
                                isChallengeResult: false,
                                time: video.durationMs.msToTimeString,
                                width: 166,
                                height: 166
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                .padding(.vertical, 12)
                
                HStack {
                    Spacer()
                    LinearGradient(
                        gradient: Gradient(
                            colors: [
                                Color.clogUI.gray700,
                                Color.clogUI.gray700.opacity(0.83),
                                Color.clogUI.gray700.opacity(0.71),
                                Color.clogUI.gray700.opacity(0.0),
                            ]
                        ),
                        startPoint: .trailing,
                        endPoint: .leading
                    )
                    .frame(width: 58)
                    .allowsHitTesting(false)
                }
            }
            .padding(.leading, 24)
            
            Spacer(minLength: 16)
        }
        .background(Color.clogUI.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func makeFavoriteCragView(_ mostVisitedCrag: MostVisitedCrag) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(mostVisitedCrag.mostVisitedCragVisitCount)회")
                        .font(.h5)
                        .foregroundStyle(Color.clogUI.white)
                    Text("방문한 최애 암장")
                        .font(.h5)
                        .foregroundStyle(Color.clogUI.gray400)
                    
                    Spacer()
                }
                
                Text("\(mostVisitedCrag.mostVisitedCragName)")
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .font(.h1)
                    .foregroundStyle(Color.clogUI.gray10)
                
                Spacer()
            }
            
            Spacer()
            Image.clogUI.reportCrag
                .resizable()
                .frame(width: 175)
        }
        .padding(.leading, 16)
        .padding(.vertical, 24)
        .background(Color.clogUI.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func makeSaveAndSharedButton() -> some View {
        Button {
            
        } label: {
            Text("저장 / 공유하기")
                .font(.b1)
                .foregroundStyle(Color.clogUI.primary)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(Color.clogUI.gray900)
                .cornerRadius(12, corners: .allCorners)
        }
    }
    
    public func informationText() -> some View {
        Text("가장 많이 도전한 문제와 암장의 경우\n다음날에 반영됩니다.")
            .font(.b2)
            .foregroundStyle(Color.clogUI.gray500)
            .multilineTextAlignment(.center)
    }
}

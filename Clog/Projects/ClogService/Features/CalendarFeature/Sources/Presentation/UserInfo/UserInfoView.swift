//
//  UserInfoView.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import DesignKit
import Shared

enum UserInfoType {
    case normal
    case detail
}

struct UserInfoView: View {
    @Bindable private var store: StoreOf<UserInfoFeature>
    private let type: UserInfoType
    @Binding private var isFocused: Bool
    
    public init(
        type: UserInfoType,
        isFocused: Binding<Bool> = .constant(false),
        store: StoreOf<UserInfoFeature>
    ) {
        self.type = type
        self._isFocused = isFocused
        self.store = store
    }
    
    var body: some View {
        makeBody()
            .background(Color.clogUI.gray900)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .onAppear {
                store.send(.onAppear)
            }
    }
}

extension UserInfoView {
    private func makeBody() -> some View {
        VStack {
            makeInfoView()
                .contentShape(Rectangle())
                .onTapGesture {
                    store.send(.dropdownTapped, animation: .default)
                }
            if store.isEditMemo {
                makeEditorView()
            } else {
                if store.isOpen {
                    makeDropdownView()
                }
            }
        }
    }
    
    // MARK: - Memo Edit View
    private func makeEditorView() -> some View {
        VStack {
            DividerView(.horizontal)
                .padding(.horizontal, 20)
            
            ClLogTextInput(
                placeHolder: "",
                text: $store.editMemo,
                isFocused: $isFocused
            )
            .type(.editor)
            .background(.gray800)
            .frame(height: 136)
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 20)
        }
    }
    
    // MARK: - InfoView
    private func makeInfoView() -> some View {
        HStack(alignment: .center) {
            switch type {
            case .normal:
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(store.userName)님,")
                        .font(.h1)
                        .foregroundColor(Color.clogUI.primary)
                    
                    HStack(spacing: 0) {
                        Text("\(store.currentMonth)월엔 ")
                            .font(.h5)
                            .foregroundColor(Color.clogUI.gray500)
                        Text("\(store.numOfClimbDays)일")
                            .font(.h5)
                            .foregroundColor(Color.clogUI.primary)
                        Text(" 클라이밍했어요")
                            .font(.h5)
                            .foregroundColor(Color.clogUI.gray500)
                    }
                }
            case .detail:
                HStack(spacing: 0) {
                    Image.clogUI.location
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.clogUI.white)
                    
                    Text(store.cragName)
                        .font(.h2)
                        .foregroundStyle(Color.clogUI.gray10)
                }
            }
            
            Spacer()
            
            if !store.isEditMemo {
                DropdownButton(isOpen: $store.isOpen) { }
                    .allowsHitTesting(false)
                    .padding(.trailing, 4)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
    
    // MARK: - 드롭다운 뷰
    private func makeDropdownView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            DividerView(.horizontal)
                .padding(.horizontal, 20)
            
            makeWorkoutDurationView()
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            DividerView(.horizontal)
                .padding(.horizontal, 20)
            
            makeAttemptCountView()
                .padding(.horizontal, 14)
                .padding(.vertical, 16)
            
            if case .detail = type {
                DividerView(.horizontal)
                    .padding(.horizontal, 20)
                
                makeProblemView()
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                
                DividerView(.horizontal)
                    .padding(.horizontal, 20)
                
                makeMemoView()
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
            }
        }
    }
    
    // MARK: - 운동 시간
    private func makeWorkoutDurationView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(
                store.currentMonth == 0 ?
                "총 운동 시간" : "\(store.currentMonth)월 총 운동 시간"
            )
            .font(.h5)
            .foregroundStyle(Color.clogUI.gray400)
            
            Text(store.totalDurationMs.msToTimeString)
                .font(.h1)
                .foregroundStyle(Color.clogUI.gray10)
        }
        .padding(.vertical, 10)
    }
    
    // MARK: - 운동 시간
    private func makeAttemptCountView() -> some View {
        HStack(spacing: 0) {
            makeAttemptView(title: "총 시도 횟수", value: store.totalAttemptsCount)
                .frame(maxWidth: .infinity)
            
            DividerView(.vertical)
            
            makeAttemptView(title: "완등 횟수", value: store.totalSuccessCount)
                .frame(maxWidth: .infinity)
            
            DividerView(.vertical)
            
            makeAttemptView(title: "실패 횟수", value: store.totalFailCount)
                .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - 운동시간 컴포넌트
    private func makeAttemptView(title: String, value: Int) -> some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.h5)
                .foregroundStyle(Color.clogUI.gray400)
            
            Text("\(value)")
                .font(.h1)
                .foregroundStyle(Color.clogUI.gray10)
        }
    }
    
    // MARK: - 푼 문제
    private func makeProblemView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("푼 문제")
                .font(.h5)
                .foregroundStyle(Color.clogUI.gray400)
            
            ForEach(store.problems.indices, id: \.self) { index in
                VStack(spacing: 4) {
                    HStack(spacing: 12) {
                        Text("문제 \(index + 1)")
                            .font(.h4)
                            .foregroundStyle(Color.clogUI.gray10)
                        HStack(spacing: 4) {
                            ForEach(0..<store.problems[index].attemptCount, id: \.self) { _ in
                                Circle()
                                    .fill(Color(hex: store.problems[index].displayColorHex))
                                    .frame(width: 24, height: 24)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - 메모
    private func makeMemoView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("메모")
                .font(.h5)
                .foregroundStyle(Color.clogUI.gray400)
            
            Text(store.memo)
                .font(.b1)
                .foregroundStyle(Color.clogUI.gray50)
        }
    }
}

#Preview {
    UserInfoView(
        type: .normal,
        store: .init(initialState: UserInfoFeature.State(), reducer: {
            UserInfoFeature()
        })
    )
}

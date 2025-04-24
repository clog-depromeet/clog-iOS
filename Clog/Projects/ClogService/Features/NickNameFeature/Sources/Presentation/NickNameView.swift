//
//  NickNameView.swift
//  NickNameFeature
//
//  Created by Junyoung on 3/30/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import DesignKit

public struct NickNameView: View {
    @Bindable private var store: StoreOf<NickNameFeature>
    
    public init(store: StoreOf<NickNameFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBody()
            .background(Color.clogUI.gray900)
            .onTapGesture {
                store.send(.focusOut)
            }
    }
}

extension NickNameView {
    private func makeBody() -> some View {
        VStack {
            if case .update = store.viewState {
                // 닉네임 수정인 경우 앱바 필요
                makeAppBar()
            }
            if case .create = store.viewState {
                // 닉네임 생성인 경우 안내 문구 출력
                informationText()
                    .padding(.horizontal, 16)
            }
            makeContent()
                .padding(.horizontal, 16)
            Spacer()
            makeBottomButton()
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
        }
    }
    
    private func makeAppBar() -> some View {
        AppBar(title: "닉네임 수정") {
            Button {
                store.send(.backButtonTapped)
            } label: {
                Image.clogUI.back
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.clogUI.white)
            }
        } rightContent: {}
    }
    
    private func informationText() -> some View {
        HStack {
            Text("닉네임만 입력하면\n시작할 수 있어요!")
                .font(.h1)
                .foregroundStyle(Color.clogUI.white)
            
            Spacer()
        }
        .frame(height: 155)
    }
    
    private func makeContent() -> some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 0) {
                Text("닉네임")
                    .font(.h5)
                    .foregroundStyle(Color.clogUI.white)
                
                Text("*")
                    .font(.h5)
                    .foregroundStyle(Color.clogUI.primary)
            }
            
            // 텍스트 필드
            VStack(spacing: 4) {
                ClLogTextInput(
                    placeHolder: "닉네임을 입력해주세요.",
                    text: $store.text,
                    isFocused: $store.focused
                )
                .background(.gray700)
                .state(store.textFieldState)
                .type(.filed)
                
                HStack {
                    if case .error = store.textFieldState {
                        Text("공백없이 한글, 영문, 숫자만 가능해요.")
                            .font(.c1)
                            .foregroundStyle(Color.clogUI.fail)
                    }
                    Spacer()
                    Text("\(store.textCount)/10")
                        .font(.c1)
                        .foregroundStyle(Color.clogUI.gray500)
                }
            }
        }
    }
    
    private func makeBottomButton() -> some View {
        GeneralButton(store.viewState.buttonTitle) {
            store.send(.confirmButtonTapped)
        }
        .style(.white)
        .disabled(store.disabled)
    }
}

#Preview {
    NickNameView(store: .init(initialState: NickNameFeature.State(viewState: .create), reducer: {
        NickNameFeature()
    }))
}

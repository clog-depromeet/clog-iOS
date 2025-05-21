//
//  ProfileEditorView.swift
//  ProfileEditorFeatureInterface
//
//  Created by Junyoung on 5/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

import ProfileEditorFeatureInterface
import DesignKit

@ViewAction(for: ProfileEditorFeature.self)
public struct ProfileEditorView: View {
    @Bindable public var store: StoreOf<ProfileEditorFeature>
    
    public init(store: StoreOf<ProfileEditorFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            appBarView
            contentView
            Spacer()
            bottomButtonView
        }
        .onTapGesture {
            send(.focusOut)
        }
        .padding(.horizontal, 16)
        .background(Color.clogUI.gray800)
    }
}

extension ProfileEditorView {
    private var appBarView: some View {
        AppBar(title: "내 프로필 편집") {
            Button {
                send(.backButtonTapped)
            } label: {
                Image.clogUI.back
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.clogUI.white)
            }
        } rightContent: { }
    }
    
    private var contentView: some View {
        ScrollView(showsIndicators: false) {
            profileImageView
            VStack(spacing: 14) {
                nicknameView
                
                HStack(spacing: 7) {
                    heightView
                    armLengthView
                }
                
                genderView
                snsView
            }
        }
    }
    
    private var profileImageView: some View {
        Button {
            
        } label: {
            ZStack(alignment: .bottomTrailing) {
                Image.clogUI.defaultProfile
                    .resizable()
                    .frame(width: 90, height: 90)
                
                Image.clogUI.edit
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(Color.clogUI.gray800)
                    .background(
                        Circle()
                            .fill(Color.white)
                            .frame(width: 30, height: 30)
                    )
                    .offset(x: 4)
            }
            .padding(.vertical, 20)
        }
    }
    
    private var nicknameView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("닉네임")
                .font(.h5)
                .foregroundStyle(Color.clogUI.white)
            
            VStack(spacing: 0) {
                ClLogTextInput(
                    placeHolder: "닉네임을 입력해주세요",
                    text: $store.nickname,
                    isFocused: $store.nicknameFocus
                )
                
                HStack {
                    Text(store.errorText)
                        .font(.c1)
                        .foregroundStyle(Color.clogUI.textFail)
                    
                    Spacer()
                    
                    Text("\(store.nickname.count)/10")
                        .font(.c1)
                        .foregroundStyle(Color.clogUI.gray500)
                }
            }
        }
    }
    
    private var bottomButtonView: some View {
        GeneralButton("저장하기") {
            
        }
        .style(.normal)
        .disabled(false)
        .padding(.bottom, 20)
    }
    
    private var heightView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("키 (cm)")
                .font(.h5)
                .foregroundStyle(Color.clogUI.white)
            
            ClLogTextInput(
                placeHolder: "cm",
                keyboardType: .numberPad,
                text: $store.height,
                isFocused: $store.heightFocus
            )
        }
    }
    
    private var armLengthView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("팔길이 (cm)")
                .font(.h5)
                .foregroundStyle(Color.clogUI.white)
            
            ClLogTextInput(
                placeHolder: "cm",
                keyboardType: .numberPad,
                text: $store.armLength,
                isFocused: $store.armLengthFocus
            )
        }
    }
    
    private var genderView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("성별")
                .font(.h5)
                .foregroundStyle(Color.clogUI.white)
            
            HStack(spacing: 7) {
                GeneralButton("남성") {
                    send(.genderTapped(.male))
                }
                .style(
                    store.gender == .male ? .white : .normal
                )
                .disabled(false)
                .padding(.bottom, 20)
                
                GeneralButton("여성") {
                    send(.genderTapped(.female))
                }
                .style(
                    store.gender == .female ? .white : .normal
                )
                .disabled(false)
                .padding(.bottom, 20)
            }
        }
    }
    
    private var snsView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("SNS")
                .font(.h5)
                .foregroundStyle(Color.clogUI.white)
            ClLogTextInput(
                placeHolder: "인스타그램 링크를 입력해주세요",
                text: $store.sns,
                isFocused: $store.snsFocus
            )
        }
    }
}

#Preview {
    ProfileEditorView(
        store: .init(
            initialState: ProfileEditorFeature.State(),
            reducer: {
                ProfileEditorFeature()
            }
        )
    )
}

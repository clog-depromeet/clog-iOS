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
        .onAppear {
            send(.onAppear)
        }
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
            /* TODO: 프로필 이미지 설정 - 스펙아웃
             profileImageView
             */
            VStack(spacing: 14) {
                nicknameView
                
                HStack(alignment: .top, spacing: 7) {
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
                    isFocused: $store.nicknameFocus,
                    configuration: TextInputConfiguration(
                        state: store.nicknameError != nil ? .error : .normal,
                        type: .filed,
                        background: .gray900
                    )
                )
                
                HStack {
                    if let error = store.nicknameError {
                        Text(error)
                            .font(.c1)
                            .foregroundStyle(Color.clogUI.fail)
                    }
                    
                    Spacer()
                    
                    Text("\(store.nickname.count)/10")
                        .font(.c1)
                        .foregroundStyle(Color.clogUI.gray500)
                }
                .padding(.top, 4)
            }
        }
    }
    
    private var bottomButtonView: some View {
        GeneralButton("저장하기") {
            send(.saveButtonTapped)
        }
        .style(store.canSave ? .normal : .error)
        .disabled(!store.canSave)
        .padding(.bottom, 20)
    }
    
    private var heightView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("키 (cm)")
                .font(.h5)
                .foregroundStyle(Color.clogUI.white)
            
            VStack(alignment: .leading, spacing: 4) {
                ClLogTextInput(
                    placeHolder: "cm",
                    keyboardType: .numberPad,
                    text: $store.height,
                    isFocused: $store.heightFocus,
                    configuration: TextInputConfiguration(
                        state: store.heightError != nil ? .error : .normal,
                        type: .filed,
                        background: .gray900
                    )
                )
                
                if let error = store.heightError {
                    Text(error)
                        .font(.c1)
                        .foregroundStyle(Color.clogUI.fail)
                        .padding(.top, 4)
                }
            }
        }
    }
    
    private var armLengthView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("팔길이 (cm)")
                .font(.h5)
                .foregroundStyle(Color.clogUI.white)
            
            VStack(alignment: .leading, spacing: 4) {
                ClLogTextInput(
                    placeHolder: "cm",
                    keyboardType: .numberPad,
                    text: $store.armLength,
                    isFocused: $store.armLengthFocus,
                    configuration: TextInputConfiguration(
                        state: store.armLengthError != nil ? .error : .normal,
                        type: .filed,
                        background: .gray900
                    )
                )
                
                if let error = store.armLengthError {
                    Text(error)
                        .font(.c1)
                        .foregroundStyle(Color.clogUI.fail)
                        .padding(.top, 4)
                }
            }
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
            
            VStack(alignment: .leading, spacing: 4) {
                ClLogTextInput(
                    placeHolder: "인스타그램 링크를 입력해주세요",
                    text: $store.sns,
                    isFocused: $store.snsFocus,
                    configuration: TextInputConfiguration(
                        state: store.snsError != nil ? .error : .normal,
                        type: .filed,
                        background: .gray900
                    )
                )
                
                if let error = store.snsError {
                    Text(error)
                        .font(.c1)
                        .foregroundStyle(Color.clogUI.fail)
                        .padding(.top, 4)
                }
            }
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

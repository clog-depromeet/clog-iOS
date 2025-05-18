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
    public var store: StoreOf<ProfileEditorFeature>
    
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
        ZStack(alignment: .center) {
            Image.clogUI.clogLogo
                .resizable()
                .frame(width: 90, height: 90)
                .padding(.vertical, 20)
        }
    }
    
    private var nicknameView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("닉네임")
                .font(.h5)
                .foregroundStyle(Color.clogUI.white)
            ClLogTextInput(
                placeHolder: "닉네임을 입력해주세요",
                text: .constant(""),
                isFocused: .constant(false)
            )
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
            Text("키")
                .font(.h5)
                .foregroundStyle(Color.clogUI.white)
            ClLogTextInput(
                placeHolder: "cm",
                text: .constant(""),
                isFocused: .constant(false)
            )
        }
    }
    
    private var armLengthView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("팔길이")
                .font(.h5)
                .foregroundStyle(Color.clogUI.white)
            ClLogTextInput(
                placeHolder: "cm",
                text: .constant(""),
                isFocused: .constant(false)
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
                    
                }
                .style(.normal)
                .disabled(false)
                .padding(.bottom, 20)
                
                GeneralButton("여성") {
                    
                }
                .style(.normal)
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
                text: .constant(""),
                isFocused: .constant(false)
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

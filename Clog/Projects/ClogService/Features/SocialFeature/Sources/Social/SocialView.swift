//
//  SocialView.swift
//  SocialFeature
//
//  Created by 강현준 on 5/16/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import DesignKit
import SocialFeatureInterface

@ViewAction(for: SocialFeature.self)
public struct SocialView: View {
    
    @Bindable public var store: StoreOf<SocialFeature>
    
    public init(
        store: StoreOf<SocialFeature>
    ){
        self.store = store
    }
    
    public var body: some View {
        makeBody()
    }
}

extension SocialView {
    private func makeBody() -> some View {
        
        VStack(spacing: 0) {
            
            makeAppBar()
            
            makeProfileCardView()
            
            Spacer()
                .frame(height: 12)
            
            makeFollowersFollowingView()
        }
        .background(Color.clogUI.gray800)
        .bottomSheet(isPresented: $store.searchBottomSheet.show) {
            makeSearchUserBottomSheet()
        }
    }
    
    private func makeAppBar() -> some View {
        AppBar(leftContent: {
            Text("팔로우")
                .font(.h3)
                .foregroundStyle(Color.clogUI.gray10)
        }, rightContent: {
            Button {
                send(.didTapSearchButton)
            } label: {
                Image.clogUI.magnifier
                    .resizable()
                    .frame(24)
                    .foregroundStyle(Color.clogUI.white)
            }
        })
    }
    
    private func makeProfileCardView() -> some View {
        VStack {
            VStack(spacing: 12) {
                HStack(spacing: 20) {
                    Image.clogUI.userprofile
                    
                    VStack(spacing: 5) {
                        HStack {
                            Text("김클로그")
                                .font(.h4)
                                .foregroundStyle(Color.clogUI.white)
                            
                            Spacer()
                                .frame(width: 6)
                            
                            Text("#1234")
                                .font(.b1)
                                .foregroundStyle(Color.clogUI.gray400)
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Image.clogUI.icn_edit
                                    .resizable()
                                    .frame(20)
                            }
                            
                        }
                        
                        HStack(spacing: 5) {
                            
                            makeHeightarmLengthLabel(type: .height, value: 163)
                            
                            makeHeightarmLengthLabel(type: .armLength, value: 175)
                            
                            Image.clogUI.icn_Instagramlogo
                            
                            Spacer()
                        }
                    }
                    .padding(.vertical, 6)
                }
                /* TODO: 프로필 공유 기능 > 기획 수정 후 추가 예정
                HStack(spacing: 7) {
                    makeShareProfileBtn()
                    makeAddFriendBtn()
                }
                 */
            }
            .padding(16)
            .background(Color.clogUI.gray900)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
    
    private func makeHeightarmLengthLabel(type: BodyInfoType, value: Int) -> some View {
        HStack(spacing: 5) {
            
            type == .height
            ? Image.clogUI.icn_height
                .resizable()
                .frame(16)
            : Image.clogUI.icn_arm_length
                .resizable()
                .frame(16)
            
            Text("\(value)")
                .font(.h5)
                .foregroundStyle(Color.clogUI.gray200)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(Color.clogUI.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private func makeShareProfileBtn() -> some View {
        Button {
            
        } label: {
            HStack {
                Spacer()
                Text("프로필 공유")
                    .font(.b1)
                    .foregroundStyle(Color.clogUI.white)
                Spacer()
            }
        }
        .frame(height: 40)
        .background(Color.clogUI.gray600)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func makeAddFriendBtn() -> some View {
        Button {
            
        } label: {
            HStack {
                Spacer()
                Text("친구 추가")
                    .font(.b1)
                    .foregroundStyle(Color.clogUI.gray800)
                Spacer()
            }
        }
        .frame(height: 40)
        .background(Color.clogUI.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func makeFollowersFollowingView() -> some View {
        SocialTabView(
            store: store.scope(
                state: \.socialTabState,
                action: \.socialTabAction
            )
        )
    }
    
    private func makeSearchUserBottomSheet() -> some View {
        VStack(alignment: .leading) {
            Text("닉네임 검색")
                .font(.h3)
                .foregroundStyle(Color.clogUI.white)
            
            Spacer().frame(height: 10)
            
            ClLogTextInput(
                placeHolder: "닉네임을 입력해주세요",
                text: $store.searchBottomSheet.searchText,
                isFocused: .constant(true)
            )
            .onChange(of: store.searchBottomSheet.searchText) { oldValue, newValue in
                send(.searchTextChanged(newValue))
            }
            
            Spacer().frame(height: 16)
            
            ForEach(store.searchBottomSheet.result) { friend in
                SocialFriendListCell(
                    friend: friend) {
                        send(.didTapFollowButton(friend))
                    }
            }
            
            Spacer()
        }
        .padding(16)
        .frame(height: 300) // TODO: 높이 조절 필요
    }
}

#Preview {
    SocialView(
        store: Store(
            initialState: SocialFeature.State(),
            reducer: {
                SocialFeature()
            }
        )
    )
}

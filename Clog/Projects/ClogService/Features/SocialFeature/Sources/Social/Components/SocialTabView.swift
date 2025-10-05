//
//  SocialTabView.swift
//  SocialFeature
//
//  Created by 강현준 on 5/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit
import Core
import SocialFeatureInterface
import SocialDomain

@ViewAction(for: SocialTabFeature.self)
public struct SocialTabView: View {
    
    @Bindable public var store: StoreOf<SocialTabFeature>
    
    public init(
        store: StoreOf<SocialTabFeature>
    ) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            
            followFollowingButtonView
            
            TabView(selection: $store.selectedTab) {
                
                makeSocialListView(
                    store.followUsers,
                    tab: .follower
                )
                
                makeSocialListView(
                    store.followingUsers,
                    tab: .following
                )
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.horizontal, 16)
        }
        .bottomSheet(isPresented: $store.profileMoreBottomSheet.show) {
            makeProfileMoreBottomSheet()
        }
        .onAppear {
            send(.onAppear)
        }
    }
    
    private var followFollowingButtonView: some View {
        HStack(spacing: 0) {
            
            ForEach(SocialTabFeature.State.CurrentTab.allCases) { tab in
                VStack(spacing: 0) {
                    
                    Button {
                        send(.selectTab(tab))
                    } label: {
                        HStack {
                            Spacer()
                            Text(tab.title)
                                .font(.b1)
                                .foregroundStyle(
                                    store.selectedTab == tab
                                    ? Color.clogUI.primary
                                    : Color.clogUI.gray400
                                )
                            Spacer()
                        }
                    }
                    
                    DividerView(
                        .horizontal,
                        color: store.selectedTab == tab
                        ? .clogUI.primary
                        : .clear
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    private func makeSocialListView(
        _ friends: [SocialFriend],
        tab: SocialTabFeature.State.CurrentTab
    ) -> some View {
        if friends.isEmpty {
            makeEmptyView(tab: tab)
        } else {
            ScrollView {
                ForEach(friends) { friend in
                    SocialFriendListCell(
                        friend: friend,
                        onFollowTap: {
                            send(.followButtonTapped(friend))
                        },
                        onMoreTap: {
                            send(.moreButtonTapped(friend))
                        }
                    )
                }
            }
            .background(Color.clogUI.gray800.ignoresSafeArea())
            .tag(tab)
        }
    }
    
    
    private func makeEmptyView(
        tab: SocialTabFeature.State.CurrentTab
    ) -> some View {
        VStack {
            tab.emptyImage
                .resizable()
                .foregroundStyle(Color.clogUI.gray500)
                .frame(60)
            
            Text(tab.emptyDescription)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.clogUI.gray500)
                .font(.h5)
            
            Spacer()
            
            /*
             // TODO: 서버 추천 목록 api 추가 시 기능 연결
            if tab == .following {
                ForEach(store.state.recommendFriends.filter { !$0.isFollowing }.prefix(3)) { friend in
                    SocialFriendListCell(friend: friend) {
                        send(.followButtonTapped(friend))
                    }
                }
            }
            */
        }
        .padding(.top, 69)
        .frame(maxWidth: .infinity)
        .background(Color.clogUI.gray800.ignoresSafeArea())
        .tag(tab)
    }
    
    private func makeProfileMoreBottomSheet() -> some View {
        VStack(alignment: .leading) {
            /* TODO: 프로필 공유 기능 > 기획 수정 후 추가 예정
            Button {
                
            } label: {
                Text("프로필 공유")
                    .font(.h4)
                    .foregroundStyle(Color.clogUI.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            */
            Button {
                send(.unfollowFromBottomSheet)
            } label: {
                Text("팔로우 취소")
                    .font(.h4)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
                    .foregroundStyle(Color.clogUI.fail)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 16)
    }
}

extension SocialTabFeature.State.CurrentTab {
    var title: String {
        switch self {
        case .follower:  "팔로워"
        case .following: "팔로잉"
        }
    }
    var emptyImage: Image {
        switch self {
        case .follower:
            return Image.clogUI.icn_follow_none
        case .following:
            return Image.clogUI.icn_follow_plus
        }
    }
    
    var emptyDescription: String {
        switch self {
        case .follower:
            return "아직 나를 팔로우한 친구가 없어요.\n지금 프로필을 공유하고, 나를 팔로우할 친구를 만나보세요!"
        case .following:
            return "관심 있는 친구를 팔로우하면\n더 다양한 활동을 볼 수 있어요."
        }
    }
}

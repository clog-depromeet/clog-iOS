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
                    [],
                    tab: .follower
                )
                
                makeSocialListView(
                    store.socialFriends.filter { $0.isFollowing },
                    tab: .following
                )
            }
        }
        
    }
    
    private var followFollowingButtonView: some View {
        HStack(spacing: 0) {
            
            VStack(spacing: 0) {
                Button {
                    send(.selectTab(.follower))
                } label: {
                    HStack {
                        Spacer()
                        Text("팔로워")
                            .font(.b1)
                            .foregroundStyle(
                                store.selectedTab == .follower
                                ? Color.clogUI.primary
                                : Color.clogUI.gray400
                            )
                        Spacer()
                    }
                }
                
                DividerView(
                    .horizontal,
                    color: store.selectedTab == .follower
                    ? .clogUI.primary
                    : .clear
                )
            }
            
            VStack(spacing: 0) {
                Button {
                    send(.selectTab(.following))
                } label: {
                    HStack {
                        Spacer()
                        Text("팔로잉")
                            .font(.b1)
                            .foregroundStyle(
                                store.selectedTab == .following
                                ? Color.clogUI.primary
                                : Color.clogUI.gray400
                            )
                        Spacer()
                    }
                }
                
                DividerView(
                    .horizontal,
                    color: store.selectedTab == .following
                    ? .clogUI.primary
                    : .clear
                )
            }
        }
    }
    
    @ViewBuilder
    private func makeSocialListView(
        _ friends: [SocialFriend],
        tab: SocialTabFeature.State.CurrentTab
    ) -> some View {
        if friends.isEmpty {
            VStack {
                Image.clogUI.icn_video_none
                    .resizable()
                    .frame(60)
                
                Text(tab.emptyListDescription)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.clogUI.gray500)
                    .font(.h5)
                
                Spacer()
            }
            .padding(.top, 69)
            .frame(maxWidth: .infinity)
            .background(Color.clogUI.gray800.ignoresSafeArea())
            .tag(tab)
        } else {
            ScrollView {
                ForEach(friends) { friend in
                    SocialFriendListCell(friend: friend)
                }
            }
            .background(Color.clogUI.gray800.ignoresSafeArea())
            .tag(tab)
        }
    }
}

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
}

//
//  SettingView.swift
//  SettingFeature
//
//  Created by Junyoung on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import DesignKit

public struct SettingView: View {
    private let store: StoreOf<SettingFeature>
    
    public init(store: StoreOf<SettingFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBody()
            .background(Color.clLogUI.gray800)
            .onAppear {
                
            }
    }
}

extension SettingView {
    private func makeBody() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                makeAppBar()
                makeProfile()
                VStack(spacing: 17) {
                    makeServiceTerms()
                    makeOther()
                }
                
                Spacer()
            }
        }
    }
    
    public func makeAppBar() -> some View {
        AppBar(title: "설정") {
            Button {
                store.send(.backButtonTapped)
            } label: {
                Image.clLogUI.back
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.clLogUI.white)
            }
            
        } rightContent: {}
    }
    
    public func makeProfile() -> some View {
        ProfileView(store: store.scope(state: \.profileState, action: \.profileAction))
            .padding(.horizontal, 16)
    }
    
    public func makeServiceTerms() -> some View {
        VStack(alignment: .leading) {
            Text("서비스 이용 방침")
                .font(.c1)
                .foregroundStyle(Color.clLogUI.gray500)
                .padding(.bottom, 12)
                .padding(.leading, 16)
            
            ForEach(store.serviceItems, id: \.self) { item in
                SettingRow(item: item) { type in
                    store.send(.settingItemTapped(type))
                }
            }
        }
        .padding(.vertical, 16)
        .background(Color.clLogUI.gray900)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }
    
    public func makeOther() -> some View {
        VStack(alignment: .leading) {
            Text("기타")
                .font(.c1)
                .foregroundStyle(Color.clLogUI.gray500)
                .padding(.bottom, 12)
                .padding(.leading, 16)
            
            ForEach(store.accountItem, id: \.self) { item in
                SettingRow(item: item) { type in
                    store.send(.settingItemTapped(type))
                }
            }
        }
        .padding(.vertical, 16)
        .background(Color.clLogUI.gray900)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }
}

#Preview {
    SettingView(
        store: .init(
            initialState: SettingFeature.State(),
            reducer: {
                SettingFeature()
            }
        )
    )
}

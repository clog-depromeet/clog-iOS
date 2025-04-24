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
    @Bindable private var store: StoreOf<SettingFeature>
    
    public init(store: StoreOf<SettingFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBody()
            .background(Color.clogUI.gray800)
            .presentDialog($store.scope(state: \.alert, action: \.alert), style: .delete)
    }
}

extension SettingView {
    private func makeBody() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                makeAppBar()
                // TODO: MVP 제외 추후 개발 예정
                // makeProfile()
                Spacer(minLength: 37)
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
                Image.clogUI.back
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.clogUI.white)
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
                .foregroundStyle(Color.clogUI.gray500)
                .padding(.bottom, 12)
                .padding(.leading, 16)
            
            ForEach(store.serviceItems, id: \.self) { item in
                SettingRow(item: item) { type in
                    store.send(.settingItemTapped(type))
                }
            }
        }
        .padding(.vertical, 16)
        .background(Color.clogUI.gray900)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }
    
    public func makeOther() -> some View {
        VStack(alignment: .leading) {
            Text("기타")
                .font(.c1)
                .foregroundStyle(Color.clogUI.gray500)
                .padding(.bottom, 12)
                .padding(.leading, 16)
            
            ForEach(store.accountItem, id: \.self) { item in
                SettingRow(item: item) { type in
                    store.send(.settingItemTapped(type))
                }
            }
        }
        .padding(.vertical, 16)
        .background(Color.clogUI.gray900)
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

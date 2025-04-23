//
//  ProfileView.swift
//  SettingFeature
//
//  Created by Junyoung on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import DesignKit

struct ProfileView: View {
    private let store: StoreOf<ProfileFeature>
    
    init(store: StoreOf<ProfileFeature>) {
        self.store = store
    }
    
    var body: some View {
        makeBody()
    }
}

extension ProfileView {
    private func makeBody() -> some View {
        HStack(alignment: .center, spacing: 15) {
            Button {
                
            } label: {
                HStack(alignment: .center, spacing: 8) {
                    Text("김클로그")
                        .font(.h4)
                        .foregroundStyle(Color.clogUI.white)
                    
                    Image.clogUI.right
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color.clogUI.gray400)
                }
            }
            
            Spacer()
        }
        .frame(height: 118)
    }
}

#Preview {
    ProfileView(
        store: .init(
            initialState: ProfileFeature.State(),
            reducer: {
                ProfileFeature()
            }
        )
    )
}

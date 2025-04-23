//
//  OnboardingView.swift
//  OnboardingFeature
//
//  Created by Junyoung on 3/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import DesignKit

public struct OnboardingView: View {
    @Bindable private var store: StoreOf<OnboardingFeature>
    
    public init(store: StoreOf<OnboardingFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBody()
            .background(Color.clogUI.gray900)
    }
}

public extension OnboardingView {
    private func makeBody() -> some View {
        ZStack(alignment: .bottom) {
            
            // Image
            TabView(selection: $store.selected){
                PageView(type: .first).tag(0)
                PageView(type: .second).tag(1)
                PageView(type: .third).tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            VStack {
                // Progress
                HStack {
                    HStack(spacing: 5) {
                        ForEach(0 ..< 3) {index in
                            Capsule()
                                .foregroundColor(
                                    store.selected == index ?
                                    Color.clogUI.primary : Color.clogUI.gray600
                                )
                                .frame(
                                    width: store.selected == index ? 26 : 6,
                                    height: 6
                                )
                                .animation(.easeInOut(duration: 0.25), value: store.selected)
                        }
                    }
                }
                .padding(.top, 44)
                
                Spacer()
                
                // Start Button
                Button {
                    store.send(.startTapped)
                } label: {
                    Text("시작하기")
                        .font(.h3)
                        .foregroundStyle(Color.clogUI.gray800)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Color.clogUI.primary)
                        .cornerRadius(12, corners: .allCorners)
                    
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    OnboardingView(
        store: .init(
            initialState: OnboardingFeature.State(),
            reducer: {
                OnboardingFeature()
            }
        )
    )
}

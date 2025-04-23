//
//  HomeView.swift
//  Clog
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import DesignKit

import LoginFeature
import AccountDomain
import SplashFeature
import OnboardingFeature
import NickNameFeature

import ComposableArchitecture

struct RootView: View {
    
    private let store: StoreOf<RootFeature>
    
    init(
        store: StoreOf<RootFeature>
    ) {
        self.store = store
    }
    
    var body: some View {
       bodyView
            .onAppear {
                store.send(.onAppear)
            }
    }
    
    private var bodyView: some View {
        ZStack {
            // 스플레시
            IfLetStore(store.scope(state: \.splashState, action: \.splashAction), then: SplashView.init)
            
            // 로그인
            IfLetStore(store.scope(state: \.loginState, action: \.loginAction), then: LoginView.init)
            
            // 메인
            IfLetStore(store.scope(state: \.mainState, action: \.mainAction), then: MainView.init)
            
            // 온보딩
            IfLetStore(store.scope(state: \.onBoardingState, action: \.onboardingAction), then: OnboardingView.init)
            
            // 닉네임
            IfLetStore(store.scope(state: \.nickNameState, action: \.nickNameAction), then: NickNameView.init)
        }
    }
}

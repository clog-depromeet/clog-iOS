//
//  HomeFeature.swift
//  Clog
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Domain

import MainFeature
import VideoFeature

import ComposableArchitecture
import LoginFeature
import SplashFeature
import OnboardingFeature
import NickNameFeature
import Shared
import Foundation
import Combine

@Reducer
public struct RootFeature {
    @Dependency(\.accountUseCase) private var accountUseCase
    @Dependency(\.loginTypeFetcherUseCase) var loginTypeFetcherUseCase
    
    enum CancelID { case kickOutNotification }
    
    @ObservableState
    public struct State: Equatable {
        var loginState: LoginFeature.State?
        var mainState: MainFeature.State?
        var splashState: SplashFeature.State? = .init()
        var onBoardingState: OnboardingFeature.State?
        var nickNameState: NickNameFeature.State?
        var isOnAppeared: Bool = false
    }
    
    public enum Action {
        case onAppear
        case changeDestination(Destination)
        
        // Splash
        case splashAction(SplashFeature.Action)
        
        // login
        case loginAction(LoginFeature.Action)
        
        // Main
        case mainAction(MainFeature.Action)
        
        // Onboarding
        case onboardingAction(OnboardingFeature.Action)
        
        // NickName
        case nickNameAction(NickNameFeature.Action)
        
        // kickout
        case didReceiveKickOutNotification
    }
    
    public var body: some ReducerOf<Self> {
        Reduce(reducerCore)
            .ifLet(\.loginState, action: \.loginAction) {
                LoginFeature()
            }
            .ifLet(\.mainState, action: \.mainAction) {
                MainFeature()
            }
            .ifLet(\.splashState, action: \.splashAction) {
                SplashFeature()
            }
            .ifLet(\.onBoardingState, action: \.onboardingAction) {
                OnboardingFeature()
            }
            .ifLet(\.nickNameState, action: \.nickNameAction) {
                NickNameFeature()
            }
    }
}

// MARK: - Reducer Core
private extension RootFeature {
    /// Home Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: Home Action
    /// - Returns: Effect<HomeAction>
    private func reducerCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .onAppear:
            guard !state.isOnAppeared else { return .none }
            state.isOnAppeared = true
            
            return Effect.publisher {
                NotificationCenter.default
                    .publisher(for: .didKickOut)
                    .map { _ -> Action in .didReceiveKickOutNotification }
                    .eraseToAnyPublisher()
            }
            .cancellable(id: CancelID.kickOutNotification)
            
        case .didReceiveKickOutNotification:
            return .run { send in
                await loginTypeFetcherUseCase.clear()
                await send(.changeDestination(.login))
            }
            
        case .splashAction(let action):
            return splashCore(&state, action)
            
        case .loginAction(let action):
            return loginCore(&state, action)
        case .nickNameAction(let action):
            return nickNameCore(&state, action)
            
        case .mainAction(let action):
            return mainCore(&state, action)
        case .changeDestination(let destination):
            // Feature 초기화
            state.splashState = nil
            state.mainState = nil
            state.onBoardingState = nil
            state.nickNameState = nil
            
            switch destination {
            case .login:
                state.loginState = LoginFeature.State()
            case .main:
                state.mainState = MainFeature.State()
            case .onBoarding:
                state.onBoardingState = OnboardingFeature.State()
            case .nickName:
                state.nickNameState = NickNameFeature.State(viewState: .create)
            }
            return .none
            
        case .onboardingAction(let action):
            return onboardingCore(&state, action)
        }
    }
}

// MARK: - Login Action
private extension RootFeature {
    
    /// 스플레시 Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: Splash Action
    /// - Returns: Effect
    func splashCore(
        _ state: inout State,
        _ action: (SplashFeature.Action)
    ) -> Effect<Action> {
        switch action {
        case .finish(let destination):
            return .send(.changeDestination(destination))
        default:
            return .none
        }
    }
    
    /// Login Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: Login Action
    /// - Returns: Effect
    func loginCore(
        _ state: inout State,
        _ action: (LoginFeature.Action)
    ) -> Effect<Action> {
        switch action {
        case .successLogin:
            return checkNickName()
        default:
            return .none
        }
    }
    /// 자동 로그인
    /// - Returns: 자동 로그인 결과
    func checkLoginStatus() -> Bool {
        // TODO: 로그인 여부 확인
        return false
    }
}

private extension RootFeature {
    
    /// Main Tab Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: Main Tab Action
    /// - Returns: Effect
    func mainCore(
        _ state: inout State,
        _ action: (MainFeature.Action)
    ) -> Effect<Action> {
        return .none
    }
}

private extension RootFeature {
    
    /// Onboarding Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: OnBoarding Action
    /// - Returns: Effect
    func onboardingCore(
        _ state: inout State,
        _ action: (OnboardingFeature.Action)
    ) -> Effect<Action> {
        switch action {
        case .startTapped:
            return .send(.changeDestination(.login))
        default:
            return .none
        }
    }
}

private extension RootFeature {
    
    /// Nickname Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: OnBoarding Action
    /// - Returns: Effect
    func nickNameCore(
        _ state: inout State,
        _ action: (NickNameFeature.Action)
    ) -> Effect<Action> {
        switch action {
        case .updateSuccess:
            // 닉네임 설정 완료
            return .send(.changeDestination(.main))
        default:
            return .none
        }
    }
}

extension RootFeature {
    private func checkNickName() -> Effect<Action> {
        .run { send in
            let user = try await accountUseCase.fetchAccount()
            if user.name != nil {
                await send(.changeDestination(.main))
            } else {
                await send(.changeDestination(.nickName))
            }
        }
    }
}

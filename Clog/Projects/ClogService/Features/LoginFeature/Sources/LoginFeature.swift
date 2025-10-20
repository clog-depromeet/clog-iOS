//
//  LoginFeature.swift
//  LoginFeature
//
//  Created by soi on 2/27/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture
import KakaoSDKUser
import AccountDomain

@Reducer
public struct LoginFeature {
    
    public init() {}
    
    @Dependency(\.loginUseCase) private var useCase
    
    public struct State: Equatable {
        public init() {}
        
        var errorMessage: String?
    }
    
    public enum Action: Equatable {
        case onAppear
        case kakaoLoginButtonTapped
        case appleLoginCompleted(authorizationCode: String?)
        case successLogin
        case failLogin
    }
    
    public var body: some ReducerOf<Self> {
        // TODO: acceess token 키체인 저장 후 화면 이동 필요
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .kakaoLoginButtonTapped:
                return .run { send in
                    do {
                        guard let idToken = try await executeKakaoLogin() else {
                            return await send(.failLogin)
                        }
                        try await useCase.execute(idToken: idToken)
                        await send(.successLogin)
                    } catch {
                        await send(.failLogin)
                    }
                }
                
            case .appleLoginCompleted(let authorizationCode):
                return .run { send in
                    guard let authorizationCode = authorizationCode else {
                        await send(.failLogin)
                        return
                    }
                    
                    do {
                        try await useCase.execute(code: authorizationCode, codeVerifier: authorizationCode)
                        await send(.successLogin)
                    } catch {
                        await send(.failLogin)
                    }
                }

            case .successLogin:
                return .none
                
            case .failLogin:
                return .none
            }
        }
    }
    
    @MainActor
    private func executeKakaoLogin() async throws -> String? {
        if UserApi.isKakaoTalkLoginAvailable() {
            return try await loginWithKakaoTalk()
        } else {
            return try await loginWithKakaoAccount()
        }
    }
    
    @MainActor
    private func loginWithKakaoTalk() async throws -> String? {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: oauthToken?.idToken)
                }
            }
        }
    }
    
    @MainActor
    private func loginWithKakaoAccount() async throws -> String? {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: oauthToken?.idToken)
                }
            }
        }
    }
}

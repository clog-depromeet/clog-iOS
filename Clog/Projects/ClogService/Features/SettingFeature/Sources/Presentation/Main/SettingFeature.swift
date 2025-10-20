//
//  SettingFeature.swift
//  SettingFeature
//
//  Created by Junyoung on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture
import AccountDomain
import SwiftUI
import AuthenticationServices

@Reducer
public struct SettingFeature {
    @Dependency(\.logoutUseCase) var logoutUseCase
    @Dependency(\.withdrawUseCase) var withdrawUseCase
    @Dependency(\.loginTypeFetcherUseCase) var loginTypeFetcherUseCase
    
    @ObservableState
    public struct State: Equatable {
        var profileState: ProfileFeature.State = ProfileFeature.State()
        
        var serviceItems = SettingItemType.serviceItems
        var accountItem = SettingItemType.accountItems
        
        @Presents var alert: AlertState<Action.Dialog>?
        
        public init() {}
    }
    
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case profileAction(ProfileFeature.Action)
        
        case onAppear
        case backButtonTapped
        case settingItemTapped(SettingItemType)
        case pushWebView(String)
        case exitToStart
        
        case logoutTapped
        case withdrawTapped
        case alert(PresentationAction<Dialog>)
        @CasePathable
        public enum Dialog: Equatable {
            case logout
            case withdraw
            case cancel
        }
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.profileState, action: \.profileAction) {
            ProfileFeature()
        }
        
        Reduce(reducerCore)
            .ifLet(\.$alert, action: \.alert)
    }
}

extension SettingFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .none
        case .settingItemTapped(let type):
            switch type {
            case .logout:
                return .send(.logoutTapped)
            case .deleteAccount:
                return .send(.withdrawTapped)
            case .privacyPolicy:
                return .send(.pushWebView("https://crimson-reason-2f1.notion.site/1abbb5f5bdf780cd8e5fe4ccb702fe23?pvs=4"))
            case .feedback:
                return .send(.pushWebView("https://docs.google.com/forms/d/e/1FAIpQLSfZ04n5p2bEMNPsjg87g4TzQdS79h3kLWn51lVisHaLcXN_sg/viewform"))
            case .termsOfService:
                return .send(.pushWebView("https://crimson-reason-2f1.notion.site/1abbb5f5bdf780a1b2d9f2cda245bf48?pvs=4"))
            default:
                return .none
            }
        case .logoutTapped:
            state.alert = AlertState {
                TextState("로그아웃")
            } actions: {
                ButtonState(action: .logout) {
                    TextState("로그아웃")
                }
                ButtonState {
                    TextState("취소")
                }
            } message: {
                TextState("로그아웃 하시겠어요?")
            }
            return .none
        case .withdrawTapped:
            state.alert = AlertState {
                TextState("탈퇴하기")
            } actions: {
                ButtonState(action: .withdraw) {
                    TextState("탈퇴하기")
                }
                ButtonState {
                    TextState("취소")
                }
            } message: {
                TextState("탈퇴하면 기록한 정보들이 사라져요.\n탈퇴하시겠어요?")
            }
            return .none
        case .alert(.presented(.logout)):
            print("로그아웃")
            return logout()
        case .alert(.presented(.withdraw)):
            print("회원탈퇴")
            return withdraw()
        default:
            return .none
        }
    }
    
    private func logout() -> Effect<Action> {
        .run { send in
            do {
                try await logoutUseCase.execute()
                await send(.exitToStart)
            } catch {
                
            }
        }
    }
    
    private func withdraw() -> Effect<Action> {
        .run { send in
            let type = loginTypeFetcherUseCase.fetch()
            
            switch type {
            case .kakao:
                try await withdrawUseCase.execute(nil)
                await send(.exitToStart)
            case .apple:
                let handler = await AppleAuthenticationHandler()
                do {
                    let authCode = try await handler.revokeAppleAccount()
                    print("authCode: \(authCode)")
                    try await withdrawUseCase.execute(authCode)
                    
                    await send(.exitToStart)
                } catch {
                    print("Apple 회원탈퇴 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - 애플 로그인 인증
class AppleAuthenticationHandler: NSObject, ASAuthorizationControllerDelegate {
    private var completion: ((Result<String, Error>) -> Void)?
    
    func revokeAppleAccount() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            self.completion = { result in
                continuation.resume(with: result)
            }
            
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = []
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.performRequests()
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let authorizationCode = appleIDCredential.authorizationCode,
               let tokenString = String(data: authorizationCode, encoding: .utf8) {
                completion?(.success(tokenString))
            } else {
                completion?(.failure(NSError(domain: "AppleAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get identity token"])))
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion?(.failure(error))
    }
}

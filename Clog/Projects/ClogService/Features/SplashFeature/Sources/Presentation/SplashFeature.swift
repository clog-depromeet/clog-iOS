//
//  SplashFeature.swift
//  SplashFeature
//
//  Created by Junyoung on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture

import AccountDomain
import SplashFeatureInterface
import UIKit

public enum Destination {
    case login
    case main
    case onBoarding
    case nickName
}

@Reducer
public struct SplashFeature {
    @Dependency(\.validateUserSessionUseCase) private var validateUserSessionUseCase
    @Dependency(\.loginUseCase) private var loginUseCase
    @Dependency(\.appVersionCheck) private var appVersionCheck
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var isAnimationFinished: Bool = false
        var isValidUserFinished: Bool = false
        
        var refreshToken: String?
        
        @Presents var alert: AlertState<Action.Dialog>?
        public init() {}
    }
    
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case animationFinished
        case validateUserSession(refershToken: String?)
        case checkCompletion
        case refershToken(refrshToken: String)
        case needUpdate(Bool)
        case finish(Destination)
        
        // 알럿
        case showDialog
        case alert(PresentationAction<Dialog>)
        @CasePathable
        public enum Dialog: Equatable {
            case confirm
        }
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce(reducerCore)
            .ifLet(\.$alert, action: \.alert)
    }
}

extension SplashFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return versionCheck()
            
        case .validateUserSession(let refershToken):
            state.refreshToken = refershToken
            state.isValidUserFinished = true
            return .send(.checkCompletion)
            
        case .animationFinished:
            state.isAnimationFinished = true
            return .send(.checkCompletion)
            
        case .checkCompletion:
            guard state.isAnimationFinished && state.isValidUserFinished else { return .none }
            
            if !SplashDataManager.hasCompleted {
                SplashDataManager.hasCompleted = true
                return .send(.finish(.onBoarding))
            }
            
            if let refreshToken = state.refreshToken {
                return .send(.refershToken(refrshToken: refreshToken))
            } else {
                return .send(.finish(.login))
            }
            
        case .needUpdate(let needUpdate):
            if needUpdate {
                return .send(.showDialog)
            } else {
                return validateUserSession()
            }

        case .refershToken(let refreshToken):
            return .run { send in
                do {
                    try await loginUseCase.execute(refreshToken: refreshToken)
                    await send(.finish(.main))
                } catch {
                    await send(.finish(.login))
                }
            }
            
        case .showDialog:
            state.alert = AlertState {
                TextState("업데이트가 필요합니다.")
            } actions: {
                ButtonState(action: .confirm) {
                    TextState("App Store로 이동")
                }
            } message: {
                TextState("중요한 개선사항이 포함된 최신 버전이 출시 되었습니다. 계속 사용하려면 업데이트가 필요합니다.")
            }
            return .none
            
        case .alert(.presented(.confirm)):
            if let url = URL(string: "itms-apps://itunes.apple.com/app/6741767026") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            return .none
            
        default:
            return .none
        }
    }
    
    private func validateUserSession() -> Effect<Action> {
        .run { send in
            let refershToken = validateUserSessionUseCase.getRefreshToken()
            await send(.validateUserSession(refershToken: refershToken))
        }
    }
    
    private func versionCheck() -> Effect<Action> {
        .run { send in
            let response = await appVersionCheck.isAppVersionLowerThanMinimum()
            await send(.needUpdate(response))
        }
    }
}

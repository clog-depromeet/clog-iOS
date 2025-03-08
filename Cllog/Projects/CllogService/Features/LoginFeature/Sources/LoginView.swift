//
//  LoginView.swift
//  LoginFeature
//
//  Created by soi on 2/27/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import UIKit
import DesignKit
import AuthenticationServices

import ComposableArchitecture

public struct LoginView: View {
    
    private let store: StoreOf<LoginFeature>
    private weak var on: UIViewController?
    
    public init(
        on: UIViewController?,
        store: StoreOf<LoginFeature>
    ) {
        self.on = on
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            makeBody()
                .background(Color.clLogUI.gray900)
        }
    }
}

extension LoginView {
    private func makeBody() -> some View {
        VStack {
            makeLogoView()
            
            Spacer()
            
            makeLoginButtons()
                .padding(.horizontal, 16)
            
            Spacer()
                .frame(height: 42)
            
            makeTermsAgreementView()
            
            Spacer()
                .frame(height: 32)
        }
    }
    
    private func makeLogoView() -> some View {
        VStack {
            Spacer()
                .frame(height: 120)
            
            Image.clLogUI.clogLogo
            
            Spacer()
                .frame(height: 20)
            
            Text("영상으로 남기는\n클라이밍 기록 서비스")
                .font(.h3)
                .foregroundColor(Color.clLogUI.primary)
                .multilineTextAlignment(.center)
                
        }
    }
    
    private func makeLoginButton(type: LoginType) -> some View {
        HStack(spacing: 20) {
            type.icon
                .renderingMode(.template)
                .foregroundStyle(Color.clLogUI.gray900)
            
            Text(type.title)
                .font(.h4)
                .foregroundStyle(Color.clLogUI.gray900)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(type.backgroundColor)
        )
    }
    
    private func makeLoginButtons() -> some View {
        
        let loginTypes = LoginType.allCases
        return VStack(spacing: 12) {
            ForEach(loginTypes, id: \.self) { type in
                switch type {
                case .kakao:
                    Button {
                        store.send(.kakaoLoginButtonTapped)
                    } label: {
                        makeLoginButton(type: type)
                    }
                case .apple:
                    
                    makeLoginButton(type: type)
                        .overlay {
                            SignInWithAppleButton { request in
                                
                            } onCompletion: { result in
                                switch result {
                                case .success(let authorization):
                                    let credential = authorization.credential as? ASAuthorizationAppleIDCredential
                                    let authorizationCode = String(data: credential?.authorizationCode ?? Data(), encoding: .utf8)
                                    store.send(.appleLoginCompleted(authorizationCode: authorizationCode))
                                    
                                case .failure:
                                    store.send(.failLogin)
                                }
                            }
                            .blendMode(.overlay)
                        }
                }
            }
        }
    }
    
    private func makeTermsAgreementView() -> some View {
        
        VStack {
            Text("가입하면 클로그의")
            
            HStack(spacing: 0) {
                Text("이용약관")
                    .underline()
                    .onTapGesture {
                        if let url = URL(string: "https://hungry-wall-289.notion.site/2edd8ad1613c407a8c6980e65efdb8a2") {
                            UIApplication.shared.open(url)
                        }
                    }
                Text(" 및 ")
                Text("개인정보 처리방침")
                    .underline()
                    .onTapGesture {
                        if let url = URL(string: "https://hungry-wall-289.notion.site/9e4258d6daf94f2da51e0e47b40b8af5") {
                            UIApplication.shared.open(url)
                        }
                    }
                Text("에 동의하게 됩니다.")
            }
        }
        .foregroundColor(Color.clLogUI.gray200)
        .font(.b2)
        .multilineTextAlignment(.center)
    }
}

#Preview {
    LoginView(
        on: nil,
        store: .init(
            initialState: LoginFeature.State(),
            reducer: {
                LoginFeature()
            }
        )
    )
}

private enum LoginType: CaseIterable {
    case kakao
    case apple
    
    var title: String {
        switch self {
        case .kakao: "카카오로 계속하기"
        case .apple: "Apple로 계속하기"
        }
    }
    
    var icon: Image {
        switch self {
        case .kakao: ClLogUI.kakaoLogo
        case .apple: ClLogUI.appleLogo
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .kakao: Color(hex: 0xFEE500)
        case .apple: ClLogUI.white
        }
    }
}

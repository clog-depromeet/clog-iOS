//
//  LoginDataSource.swift
//  Data
//
//  Created by soi on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Networker

import Moya

public protocol AuthDataSource {
    func kakaoLogin(idToken: String) async throws -> AuthTokenDTO
    func appleLogin(code: String, codeVerifier: String) async throws -> AuthTokenDTO
    func refresh(refreshToken: String) async throws -> AuthTokenDTO
}

public struct DefaultAuthDataSource: AuthDataSource {
    private typealias AuthTokenResponseType = BaseResponseDTO<AuthTokenDTO>
    
    private let authorizedProvider: MoyaProvider<LoginTarget>
    private let plainProvider: MoyaProvider<LoginTarget>

    public init() {
        self.authorizedProvider = MoyaProvider<LoginTarget>.authorized()
        self.plainProvider = MoyaProvider<LoginTarget>.plain()
    }
    
    public func kakaoLogin(idToken: String) async throws-> AuthTokenDTO {
        let request = KakaoLoginReqeustDTO(idToken: idToken)
        let response: AuthTokenResponseType = try await plainProvider.request(.kakaoLogin(request))
        
        guard let data = response.data else {
            throw NetworkError.decoding
        }
        
        return data
    }
    
    public func appleLogin(
        code: String,
        codeVerifier: String
    ) async throws -> AuthTokenDTO {
        let request = AppleLoginRequestDTO(code: code, codeVerifier: codeVerifier)
        let response: AuthTokenResponseType = try await plainProvider.request(.appleLogin(request))
        
        guard let data = response.data else {
            throw NetworkError.decoding
        }
        
        return data
    }

    public func refresh(refreshToken: String) async throws -> AuthTokenDTO {
        let request = RefreshReqeustDTO(refreshToken: refreshToken)
        let response: AuthTokenResponseType = try await authorizedProvider.request(.refresh(request))
        
        guard let data = response.data else {
            throw NetworkError.decoding
        }
        return data
    }
}

private enum LoginTarget {
    case kakaoLogin(KakaoLoginReqeustDTO)
    case appleLogin(AppleLoginRequestDTO)
    case refresh(RefreshReqeustDTO)
}

extension LoginTarget: TargetType {
    var baseURL: URL {
        return URL(string:Environment.baseURL + "/api/v1/auth")!
    }
    
    var path: String {
        switch self {
        case .kakaoLogin: 
            return "/kakao"
        case .appleLogin:
            return "/apple"
        case .refresh:
            return "/reissue/access-token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoLogin, .appleLogin, .refresh:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .kakaoLogin(let kakaoLoginReqeustDTO):
            return .requestJSONEncodable(kakaoLoginReqeustDTO)
        case .appleLogin(let appleLoginRequestDTO):
            return .requestJSONEncodable(appleLoginRequestDTO)
        case .refresh(let refreshReqeustDTO):
            return .requestJSONEncodable(refreshReqeustDTO)
        }
    }
}

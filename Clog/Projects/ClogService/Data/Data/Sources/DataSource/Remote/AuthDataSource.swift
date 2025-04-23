//
//  LoginDataSource.swift
//  Data
//
//  Created by soi on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Starlink
import Networker
import Foundation

public protocol AuthDataSource {
    func kakaoLogin(idToken: String) async throws -> AuthTokenDTO
    func appleLogin(code: String, codeVerifier: String) async throws -> AuthTokenDTO
    func refresh(refreshToken: String) async throws -> AuthTokenDTO
}

public final class DefaultAuthDataSource: AuthDataSource {
    private let unAuthProvider: Provider
    private let authProvider: Provider

    public init(unAuthProvider: Provider, authProvider: Provider) {
        self.unAuthProvider = unAuthProvider
        self.authProvider = authProvider
    }
    
    public func kakaoLogin(idToken: String) async throws-> AuthTokenDTO {
        let request = KakaoLoginReqeustDTO(idToken: idToken)
        
        let response: BaseResponseDTO<AuthTokenDTO> = try await unAuthProvider.request(
            LoginTarget.kakaoLogin(request)
        )
        
        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
            
        }
        
        return data
        
    }
    
    public func appleLogin(code: String, codeVerifier: String) async throws -> AuthTokenDTO {
        let request = AppleLoginRequestDTO(code: code, codeVerifier: codeVerifier)
        
        let response: BaseResponseDTO<AuthTokenDTO> = try await unAuthProvider.request(
            LoginTarget.appleLogin(request)
        )
        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
            
        }
        
        return data
    }

    public func refresh(refreshToken: String) async throws -> AuthTokenDTO {
        let request = RefreshReqeustDTO(refreshToken: refreshToken)

        let response: BaseResponseDTO<AuthTokenDTO> = try await authProvider.request(
            LoginTarget.refresh(request)
        )

        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)

        }

        return data
    }
}

enum LoginTarget {
    case kakaoLogin(KakaoLoginReqeustDTO)
    case appleLogin(AppleLoginRequestDTO)
    case refresh(RefreshReqeustDTO)
}

extension LoginTarget: EndpointType {
    
    var baseURL: String {
        return Environment.baseURL
    }
    
    var path: String {
        switch self {
        case .kakaoLogin: 
            return "/api/v1/auth/kakao"
        case .appleLogin:
            return "/api/v1/auth/apple"
        case .refresh:
            return "/api/v1/auth/reissue/access-token"
        }
    }
    
    var method: Starlink.Method {
        switch self {
        case .kakaoLogin, .appleLogin, .refresh:
            return .post
        }
    }
    
    var parameters: ParameterType? {
        switch self {
        case .kakaoLogin(let request):
            return .encodable(request)
        case .appleLogin(let request):
            return .encodable(request)

        case .refresh(let request):
            return .encodable(request)
        }
    }
    
    var encodable: Encodable? {
        switch self {
        case .kakaoLogin(let request):
            return request
        case .appleLogin(let request):
            return request
        case .refresh(let request):
            return request
        }
    }
    
    var headers: [Starlink.Header]? {
        nil
    }
    
    var encoding: any StarlinkEncodable {
        Starlink.StarlinkJSONEncoding()
    }
}

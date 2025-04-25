//
//  Provider.swift
//  Networker
//
//  Created by Junyoung on 4/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Alamofire
import Moya

public extension MoyaProvider {
    /// 인증이 필요한 요청을 위한 Provider입니다.
    /// 내부적으로 Token 기반 인증 흐름(AuthenticationInterceptor 등)이 적용됩니다.
    static func authorized<T: TargetType>(_ token: TokenDTO?) -> MoyaProvider<T> {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // 요청에 대한 타임아웃 10초
        configuration.timeoutIntervalForResource = 10 // 리소스에 대한 타임아웃 10초
        
        let tokenCredential = TokenAuthenticationCredential(token)
        let authenticatorInterceptor = AuthenticationInterceptor(
            authenticator: TokenAuthenticator(),
            credential: tokenCredential
        )
        
        let session = Session(
            configuration: configuration,
            interceptor: authenticatorInterceptor
        )
        
        return MoyaProvider<T>(session: session)
    }
    
    /// 인증이 필요 없는 요청을 위한 Provider입니다.
    /// 별도의 인증 로직 없이 기본 구성만으로 요청을 수행합니다.
    static func plain<T: TargetType>() -> MoyaProvider<T> {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // 요청에 대한 타임아웃 10초
        configuration.timeoutIntervalForResource = 10 // 리소스에 대한 타임아웃 10초
        
        let session = Session(configuration: configuration)
        
        return MoyaProvider<T>(session: session)
    }
}

public extension MoyaProvider {
    /// 반환 타입이 있는 요청
    func request<T: Decodable>(_ target: Target) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    
                    guard (200...300).contains(response.statusCode) else {
                        continuation.resume(throwing: NetworkError.underlying(response))
                        return
                    }
                    
                    do {
                        let result = try JSONDecoder().decode(T.self, from: response.data)
                        continuation.resume(returning: result)
                    } catch {
                        continuation.resume(throwing: NetworkError.decoding)
                    }
                    
                case .failure(let error):
                    continuation.resume(throwing: NetworkError.unknown)
                }
            }
        }
    }
    
    /// 반환 타입이 없는 요청
    func request(_ target: Target) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    guard (200...300).contains(response.statusCode) else {
                        continuation.resume(throwing: NetworkError.underlying(response))
                        return
                    }
                    continuation.resume(returning: ())
                    
                case .failure(let error):
                    continuation.resume(throwing: NetworkError.unknown)
                }
            }
        }
    }
}

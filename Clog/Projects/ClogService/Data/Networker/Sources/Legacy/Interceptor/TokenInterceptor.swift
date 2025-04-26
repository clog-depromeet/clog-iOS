//
//  TokenInterceptor.swift
//  Networker
//
//  Created by soi on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Starlink

//public final class TokenInterceptor: StarlinkInterceptor, Sendable {
//    private let tokenProvider: @Sendable () -> TokenDTO?
//    
//    public init(provider: @escaping @Sendable () -> TokenDTO?) {
//        tokenProvider = provider
//    }
//    
//    public func adapt(_ urlRequest: inout URLRequest) async throws -> URLRequest {
//        guard let token = tokenProvider() else {
//            return urlRequest
//        }
//        
//        var request = urlRequest
//        request.setHeader(.init(name: "Authorization", value: token.accessToken))
//        request.setHeader(.init(name: "Provider", value: token.provider))
//        return request
//    }
//    
//    /// retry 함수
//    /// - Parameters:
//    ///   - urlRequest: 요청 정보
//    ///   - response: 응답 값
//    /// - Returns: 다시 요청 할 URLRequest, StartlinkRetryType (retry, doNotRetry)
//    public func retry(
//        _ urlRequest: inout URLRequest,
//        response: Starlink.Response
//    ) async throws -> (URLRequest, StartlinkRetryType) {
//        guard let token = tokenProvider() else {
//            // 재 요청을 할 수 없는 상태
//            return (urlRequest, .doNotRetry)
//        }
//        // refreshToken을 요청하여 다시 retry
//        urlRequest.setHeader(.init(name: "Authorization", value: token.refreshToken))
//        urlRequest.setHeader(.init(name: "Provider", value: token.provider))
//        return (urlRequest, .retry)
//    }
//}

//
//  AuthProvider.swift
//  Networker
//
//  Created by Junyoung on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Starlink
import Pulse

// 로그인 후 토큰이 필요한 요청을 처리하는 Provider
public final class AuthProvider: Provider, Sendable {
//    private let tokenInterceptor: TokenInterceptor
//    
//    public init(tokenProvider: @escaping @Sendable () -> TokenDTO?) {
//        self.tokenInterceptor = TokenInterceptor(provider: tokenProvider)
//    }
    
    public func request<T: Decodable>(_ endpoint: EndpointType) async throws -> T {
        let url = endpoint.baseURL + endpoint.path
        
        let configure = Starlink.default()
        let session = URLSessionProxy(configuration: .default, delegate: configure.delegate)
        
        let reqeust = switch endpoint.parameters {
        case .none:
            request(
                url: url,
                endPoint: endpoint,
                session: session,
                interceptors: [
                    AppInfoInterceptor(),
//                    tokenInterceptor
                ]
            )
            
        case .some(let type):
            switch type {
            case .dictionary(let parameters):
                request(
                    url: url,
                    endPoint: endpoint,
                    session: session,
                    parameters: parameters,
                    interceptors: [
                        AppInfoInterceptor(),
//                        tokenInterceptor
                    ]
                )
            case .encodable(let parameters):
                request(
                    url: url,
                    endPoint: endpoint,
                    session: session,
                    parameters: parameters,
                    interceptors: [
                        AppInfoInterceptor(),
//                        tokenInterceptor
                    ]
                )
            }
        }
        
        let response: T = try await reqeust.reponseAsync()
        
        return response
    }
}

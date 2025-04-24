//
//  UnAuthProvider.swift
//  Networker
//
//  Created by Junyoung on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Starlink
import Pulse

// 로그인 전 토큰 없이 API 요청을 처리하는 Provider
public final class UnAuthProvider: Provider {
    public init () {}
    
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
                interceptors: [AppInfoInterceptor()]
            )
            
        case .some(let type):
            switch type {
            case .dictionary(let parameters):
                request(
                    url: url,
                    endPoint: endpoint,
                    session: session,
                    parameters: parameters,
                    interceptors: [AppInfoInterceptor()]
                )
            case .encodable(let parameters):
                request(
                    url: url,
                    endPoint: endpoint,
                    session: session,
                    parameters: parameters,
                    interceptors: [AppInfoInterceptor()]
                )
            }
        }
        
        let response: T = try await reqeust.reponseAsync()
        
        return response
    }
}

//
//  UploadProvider.swift
//  Networker
//
//  Created by lin.saeng on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

// Apple Module
import Foundation

// 내부 Module
import Starlink

// 외부 Module
import Pulse

public final class UploadProvider: UploadProviderable, Sendable {
    
    private let tokenInterceptor: TokenInterceptor
    
    public init(tokenProvider: @escaping @Sendable () -> TokenDTO?) {
        self.tokenInterceptor = TokenInterceptor(provider: tokenProvider)
    }
    
    public func uploadRequest<T: Decodable>(
        _ endpoint: EndpointType,
        _ uploadData: UploadDataForm
    ) async throws -> T {
        let url = endpoint.baseURL + endpoint.path
        
        let configure = Starlink.default()
        let session = URLSessionProxy(configuration: .default, delegate: configure.delegate)
        let reqeust = switch endpoint.parameters {
        case .none:
            fatalError()
            
        case .some(let type):
            switch type {
            case .dictionary(let parameters):
                fatalError()
            case .encodable(let parameters):
                uploadRequest(
                    url: url,
                    endPoint: endpoint,
                    uploadForm: uploadData,
                    session: session,
                    parameters: parameters,
                    interceptors: [
                        AppInfoInterceptor(),
                        tokenInterceptor
                    ]
                )
            }
        }
        let response: T = try await reqeust.uploadResponse(retryURLRequest: nil)
        
        return response
    }
}

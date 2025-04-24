//
//  StarlinkURLEncoding.swift
//  Starlink
//
//  Created by lin.saeng on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

extension Starlink {
    
    public struct StarlinkURLEncoding: StarlinkEncodable, Sendable {
        
        public init() {}
        
        public func encode(
            _ urlRequest: inout URLRequest,
            with parameters: [String: Any]?
        ) throws -> URLRequest {
            guard let parameters = parameters, !parameters.isEmpty else {
                return urlRequest
            }
            
            guard let url = urlRequest.url, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                throw StarlinkError.inValidURLPath(
                    ErrorInfo(code: "-999", error: nil, message: nil)
                )
            }
            
            components.queryItems = parameters.map { (key, value) in
                URLQueryItem(name: key, value: "\(value)")
            }
            
            urlRequest.url = components.url
            return urlRequest
        }
    }
}

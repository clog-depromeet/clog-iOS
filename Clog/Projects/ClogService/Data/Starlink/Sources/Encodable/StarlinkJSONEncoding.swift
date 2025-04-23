//
//  StarlinkJSONEncoding.swift
//  Starlink
//
//  Created by lin.saeng on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

extension Starlink {
    
    public struct StarlinkJSONEncoding: StarlinkEncodable, Sendable {
        
        public init() {}
        
        public func encode(
            _ urlRequest: inout URLRequest,
            with parameters: [String: Any]?
        ) throws -> URLRequest {
            guard let parameters = parameters, !parameters.isEmpty else {
                return urlRequest
            }
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                throw StarlinkError.inValidJSONData(nil)
            }
            urlRequest.httpBody = httpBody
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            return urlRequest
        }
    }
}

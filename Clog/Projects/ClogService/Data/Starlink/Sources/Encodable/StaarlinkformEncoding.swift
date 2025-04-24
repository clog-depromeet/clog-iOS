//
//  StaarlinkformEncoding.swift
//  Starlink
//
//  Created by lin.saeng on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

extension Starlink {
    
    public struct StarlinkFormEncoding: StarlinkEncodable, Sendable {
        
        public init() {}
        
        public func encode(
            _ urlRequest: inout URLRequest,
            with parameters: [String: Any]?
        ) throws -> URLRequest {
            
            guard let parameters = parameters, !parameters.isEmpty else {
                return urlRequest
            }

            let encodedString = parameters.map { key, value in
                let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
                let encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "\(value)"
                return "\(encodedKey)=\(encodedValue)"
            }.joined(separator: "&")

            guard let data = encodedString.data(using: .utf8) else {
                throw StarlinkError.nullPointData(nil)
            }

            urlRequest.httpBody = data
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            return urlRequest
        }
    }
}

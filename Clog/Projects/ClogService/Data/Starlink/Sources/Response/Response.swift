//
//  Response.swift
//  Starlink
//
//  Created by saeng lin on 2/15/25.
//

import Foundation

public extension Starlink {
    
    struct Response: Sendable {
        public let response: URLResponse?
        public let data: Data?
        public let error: Error?
        
        let responseTime: Date
        
        init(
            response: URLResponse?,
            data: Data?,
            error: Error?,
            responseTime: Date = Date()
        ) {
            self.response = response
            self.data = data
            self.error = error
            self.responseTime = responseTime
        }
    }
}

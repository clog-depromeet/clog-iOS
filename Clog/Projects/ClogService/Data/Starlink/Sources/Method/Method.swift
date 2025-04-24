//
//  Method.swift
//  Starlink
//
//  Created by saeng lin on 2/15/25.
//

import Foundation

public extension Starlink {
    enum Method: String, Sendable, Hashable {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
    }
}

//
//  Encodable.swift
//  Starlink
//
//  Created by lin.saeng on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol StarlinkEncodable: Sendable {
    func encode(_ urlRequest: inout URLRequest, with parameters: [String: Any]?) throws -> URLRequest
}

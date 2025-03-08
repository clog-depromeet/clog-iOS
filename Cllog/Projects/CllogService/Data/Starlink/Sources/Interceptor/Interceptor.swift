//
//  Interceptor.swift
//  Starlink
//
//  Created by saeng lin on 2/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol StarlinkInterceptor {
    func adapt(_ urlRequest: inout URLRequest) async throws -> URLRequest
}

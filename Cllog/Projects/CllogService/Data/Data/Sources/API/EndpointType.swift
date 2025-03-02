//
//  EndpointType.swift
//  Data
//
//  Created by soi on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Starlink

protocol EndpointType {
    var baseURL: String { get }
    var path: String { get }
    var method: Starlink.Method { get }
    var parameters: ParameterType? { get }
    var encodable: Encodable? { get }
    var headers: [Starlink.Header]? { get }
}

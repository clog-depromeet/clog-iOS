//
//  NetworkError.swift
//  Networker
//
//  Created by Junyoung on 4/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Moya

public enum NetworkError: Error {
    case underlying(Response)
    case failure(Error)
    case decoding
    case unknown
    case tokenEmpty
}

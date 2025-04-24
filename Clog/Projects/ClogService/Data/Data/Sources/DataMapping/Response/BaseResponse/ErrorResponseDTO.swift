//
//  ErrorResponseDTO.swift
//  Data
//
//  Created by soi on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

struct ErrorResponseDTO: Decodable {
    let name: String
    let code: String
    let message: String
}

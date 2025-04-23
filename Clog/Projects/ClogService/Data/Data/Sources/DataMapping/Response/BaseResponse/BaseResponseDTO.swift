//
//  BaseResponseDTO.swift
//  Data
//
//  Created by soi on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

struct BaseResponseDTO<T: Decodable>: Decodable {
    let data: T?
}

struct EmptyResponseDTO: Decodable { }

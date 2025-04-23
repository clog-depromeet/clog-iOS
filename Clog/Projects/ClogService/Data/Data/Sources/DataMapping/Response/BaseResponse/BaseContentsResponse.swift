//
//  BaseContentsResponse.swift
//  Data
//
//  Created by soi on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

struct BaseContentsResponse<T: Decodable, M: Decodable>: Decodable {
    let contents: T
    let meta: M?
}

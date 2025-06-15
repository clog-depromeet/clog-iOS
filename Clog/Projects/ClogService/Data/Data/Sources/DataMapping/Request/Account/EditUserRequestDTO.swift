//
//  EditUserRequestDTO.swift
//  Data
//
//  Created by Junyoung on 6/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct EditUserRequestDTO: Encodable {
    let name: String
    let height: Int
    let armSpan: Int
    let instagramUrl: String
}

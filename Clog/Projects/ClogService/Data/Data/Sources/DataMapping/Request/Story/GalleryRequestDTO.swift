//
//  GalleryRequestDTO.swift
//  Data
//
//  Created by soi on 6/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
//import Domain

public struct GalleryRequestDTO: Encodable {
    let date: String
    let cragId: Int?
    let memo: String?
    let videos: [VideoRequestDTO]
}

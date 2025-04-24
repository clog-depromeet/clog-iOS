//
//  EditMemoRequestDTO.swift
//  Data
//
//  Created by Junyoung on 3/22/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct EditMemoRequestDTO: Encodable {
    let storyId: Int
    let body: EditMemoRequestBody
}

public struct EditMemoRequestBody: Encodable {
    let memo: String
}

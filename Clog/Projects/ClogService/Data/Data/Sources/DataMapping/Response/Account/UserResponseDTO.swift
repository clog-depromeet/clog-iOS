//
//  UserResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/30/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import AccountDomain

public struct UserResponseDTO: Decodable {
    let id: Int
    let name: String?
    let height: Int?
    let armSpan: Int?
    let instagramUrl: String?
    
    func toDomain() -> User {
        return User(
            id: id,
            name: name,
            height: height,
            armSpan: armSpan,
            instagramUrl: instagramUrl
        )
    }
}

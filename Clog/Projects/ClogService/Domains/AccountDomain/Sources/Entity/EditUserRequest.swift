//
//  EditUserRequest.swift
//  AccountDomain
//
//  Created by Junyoung on 6/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct EditUserRequest {
    public let name: String
    public let height: Int
    public let armSpan: Int
    public let instagramUrl: String

    public init(
        name: String,
        height: Int,
        armSpan: Int,
        instagramUrl: String
    ) {
        self.name = name
        self.height = height
        self.armSpan = armSpan
        self.instagramUrl = instagramUrl
    }
}

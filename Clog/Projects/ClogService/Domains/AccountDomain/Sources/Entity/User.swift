//
//  User.swift
//  AccountDomain
//
//  Created by Junyoung on 3/30/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct User {
    public let id: Int
    public let name: String?
    
    public init(id: Int, name: String?) {
        self.id = id
        self.name = name
    }
}

//
//  AccountRepository.swift
//  AccountDomain
//
//  Created by Junyoung on 3/30/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

// TODO: 추후 분리 필요
public protocol AccountRepository {
    func fetchAccount() async throws -> User
    func updateName(_ name: String) async throws
}

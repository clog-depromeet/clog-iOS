//
//  LogoutRepository.swift
//  AccountDomain
//
//  Created by Junyoung on 3/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol LogoutRepository {
    func logout() async throws
}

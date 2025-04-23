//
//  DefaultLogoutRepository.swift
//  Data
//
//  Created by Junyoung on 3/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import AccountDomain

public struct DefaultLogoutRepository: LogoutRepository {
    private let userDataSource: UserDataSource
    private let tokenDataSource: TokenDataSource
    
    public init(
        userDataSource: UserDataSource,
        tokenDataSource: TokenDataSource
    ) {
        self.userDataSource = userDataSource
        self.tokenDataSource = tokenDataSource
    }
    
    public func logout() async throws {
        do {
            try await userDataSource.logout()
            tokenDataSource.clearToken()
        } catch {
            throw error
        }
    }
}

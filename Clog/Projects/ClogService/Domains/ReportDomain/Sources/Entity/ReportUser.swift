//
//  ReportUser.swift
//  ReportDomain
//
//  Created by soi on 10/5/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct ReportUser: Equatable {
    public let userId: String?
    public let userName: String?
    
    public init(userId: String?, userName: String?) {
        self.userId = userId
        self.userName = userName
    }
    
    /// 현재 로그인한 사용자의 리포트를 나타냅니다
    public static func me() -> ReportUser {
        return ReportUser(userId: nil, userName: nil)
    }
    
    /// 내 리포트인지 확인
    public var isMe: Bool {
        guard let userId, userId.isEmpty else { return false }
        return true
    }
}

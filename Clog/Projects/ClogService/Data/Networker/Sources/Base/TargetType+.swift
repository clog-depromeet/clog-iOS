//
//  TargetType+.swift
//  Networker
//
//  Created by Junyoung on 4/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Moya

public extension TargetType {
    // Header 기본 구현
    var headers: [String: String]? {
        Headers.contentJson
    }
}
